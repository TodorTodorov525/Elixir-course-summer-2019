# Elixir course lesson №11

## GenServer

https://hexdocs.pm/elixir/GenServer.html

GenServer is the Elixir's abstraction of an client - server implementation. The GenServer itself is a single process(in terms of OS processes), but it can be constructed by many asynchronic processes which will be working concurently. Racing each other to commmunicate with the main(server) process.
The server side has a build in memory which can hold any values, it is called state. State is an important part of the GenServer because it provides information passing through processes from one or different GenServer. It is analogical to the Agent's state.


There are a few server callbacks:

```
init
handle_call
handle_cast
handle_info
terminate
code_change
```

Those to which we will pay more attention to are the ones used for handling interprocess communication  handle_call, handle_cast and handle_info. `handle_call` must be used for synchronous requests. This should be the default choice as waiting for the server reply is a useful backpressure mechanism.  But it must be used carefully because it blocks the IO stream (asynchronous processes are not blocked).  `handle_cast` must be used for asynchronous requests, when you don’t care about a reply. A cast does not even guarantee the server has received the message and, for this reason, should be used sparingly.
`handle_info` must be used for all other messages a server may receive that are not sent via GenServer.call/2 or GenServer.cast/2, including regular messages sent with send/2.

Since any message, including the ones sent via send/2, go to handle_info/2, there is a chance unexpected messages will arrive to the server. Therefore, if we don’t define the catch-all clause, those messages could cause our registry to crash, because no clause would match. We don’t need to worry about such cases for handle_call/3 and handle_cast/2 though. Calls and casts are only done via the GenServer API, so an unknown message is quite likely a developer mistake.



In order to start our GenServer , we will need to add two additional functions.
The init/1 function is a required callback for the GenServer protocol. This function accepts one arbitrary parameter. In our case, we will be passing in the initial state of our system. While in a complex system, there may be a complex init/1 function, in our case, we simply return a tuple with the state that was passed in.

```
def init(queue) do
  {:ok, queue}
end
```

Then we can implement functionality which can update the GenServer's state. In order for it to be the only one which will be executed by the user at a single moment of time we use the `GenServer.call` method specifing the atom `:cal` as a marker for expressing what are we 'calling'.
```
def cal() do
    GenServer.call(__MODULE__, :cal)
end
```

And the server callback which shall return a reply to the server we specify a hadnle to an exact marker, and then we send a reply, whose second parameter is the value/message that will be printed as a result of that whole syncronicous call in the terminal. And as a third argument the new value of the state(it can be the old one if we havent made any changes to the value).
```
def handle_call(:cal, from, state) do
  {:reply, :syn, state ++ [1]}
end
```

We can also implement a functionality which will make an asynchronicous call to the server, in order to do that we can use `GenServer.cast` also specifying an atom as a marker is needed. In the example the marker is `cas`. It won't block the IO, it will be executed in background and it is also possible to call multiple to run concurently.
```
def cas() do
  GenServer.cast(__MODULE__, :cas)
end
```

The server reply doesn't return a reply to the server. But the state's value can also be updated.
```
def handle_cast(:cas, state) do
  {:noreply, state ++ ["x"]}
end
```

It is good to implement a functionality which will handle any other incoming messages that are not defined in the call and cast callbacks.
```
def handle_info(any, state) do
  IO.inspect("any case : #{IO.inspect(any)}")
  {:noreply, state ++ [any]}
end

iex(2)> {:ok, pid} = Gen.start
{:ok, #PID<0.185.0>}
iex(3)> send(pid, "alabala")  
"alabala"
"alabala"
"any case : alabala"
iex(4)> Gen.print
["alabala"]
```


Example:

This is how we can implement a GenServer using only processes.
```
defmodule SimpleGenServerMock do
   def start_link() do
       # runs in the caller context Alice
       spawn_link(__MODULE__, :init, [])
   end
   def call(pid, arguments) do
       # runs in the caller context Alice
       send pid, {:call, self(), arguments}
       receive
         {:response, data} -> data
       end
   end
   def cast(pid, arguments) do
       # runs in the caller context Alice
       send pid, {:cast, arguments}
   end
   def init() do
      # runs in the server context Bob
      initial_state = 1
      loop(initial_state)
   end
   def loop(state) do
      # runs in the server context Bob
      receive command do
         {:call, pid, :get_data} ->
           # do some work on data here and update state
           {new_state, response} = {state, state}
           send pid, {:response, data}
           loop(new_state)
         {:cast, :increment} ->
           # do some work on data here and update state
           new_state = state + 1
           loop(new_state)
      end
   end
end
```

Same implementation but this time using GenServer
```
defmodule SimpleGenServerBehaviour do
  use GenServer
  def start_link() do
    # runs in the caller context Alice
    GenServer.start_link(__MODULE__, [])
  end
  def init(_) do
    # runs in the server context Bob
    {:ok, 1}
  end
  def handle_call(:get_data, _, state) do
    # runs in the server context Bob
    {:reply, state, state}
  end
  def handle_cast(:increment, state) do
    # runs in the server context Bob
    {:noreply, state+1}
  end
end
```


Gracefull shutdown of the server
```
def terminate(reason, state) do
  IO.puts "server terminated because of #{inspect reason}"
  :ok
end
```

Good to knows:
If a new instance of GenServer is made it will have its own state.
GenServer cannot initiate calls passing his own ID.
The shell is its own process, through it calls to the GenServer's parent ID can be made. 
The only way to implement a GenServer which shall call itself is by the creation of an linked process in which the new procedure call will be made.

https://elixir-lang.org/cheatsheets/gen-server.pdf

# Exercises:

1. Implement a GenServer which shall synchroniusly add in a state map a key value pair ex: "a" => 1 and asynchronicaly messages in a list which can be accessed through a key named "async". Implement a gracefull shutdown and a print.


2. Implement two GenServers which shall have functionality for passing messages to each other and to themselves. The messages shall be saved in the GenServer's state. 































































```
Some servers are effectively stateless. If we had a server that calculated the
factors of numbers or responded to network requests with the current time,
we could simply restart it and let it run.
But our server is not stateless—it needs to remember the current number so
it can generate an increasing sequence.
All of the approaches to this involve storing the state outside of the process.
Let’s choose a simple option—we’ll write a separate worker process that can
store and retrieve a value. We’ll call it our stash. The sequence server can
store its current number in the stash whenever it terminates, and then we
can recover the number when we restart.
At this point, we have to think about lifetimes. Our sequence server should
be fairly robust, but we’ve already found one thing that crashes it. So in
actuarial terms, it isn’t the fittest process in the scheduler queue. But our
stash process must be more robust—it must outlive the sequence server, at
the very least.
We have to do two things to make this happen. First, we make it as simple
as possible. The fewer moving parts in a chunk of code, the less likely it is to
go wrong.
Second, we have to supervise it separately. In fact, we’ll create a supervision
tree. It’ll look like the following diagram:
Chapter 18. OTP: Supervisors • 234
report erratum • discuss
Main Supervisor
Stash Worker Subsupervisor
Sequence
Worker
Here we have a top-level supervisor that is responsible for the health of two
things: the stash worker and a second supervisor. That second supervisor
then manages the worker that generates the sequence.
Our sequence generator needs to know the PID of the stash in order to retrieve
and store the sequence value. We could register the stash process under a
name (just as we did with the sequence worker itself), but as this is purely a
local affair, we can pass it the PID directly. However, to do that we need to
get the stash worker spawned first. This leads to a slightly different design
for the top-level supervisor. We’ll move the code that starts the top-level
supervisor out of sequence.ex and into a separate module. Then we’ll initialize
it with no children and add the stash and the subsupervisor manually. Once
we start the stash worker, we’ll have its PID, and we can then pass it on to
the subsupervisor (which in turn will pass it to the sequence worker). Our
overall supervisor looks like this:
otp-supervisor/2/sequence/lib/sequence/supervisor.ex
Line 1 defmodule Sequence.Supervisor do
- use Supervisor
- def start_link(initial_number) do
- result = {:ok, sup } = Supervisor.start_link(__MODULE__, [initial_number])
5 start_workers(sup, initial_number)
- result
- end
- def start_workers(sup, initial_number) do
- # Start the stash worker
10 {:ok, stash} =
- Supervisor.start_child(sup, worker(Sequence.Stash, [initial_number]))
- # and then the subsupervisor for the actual sequence server
- Supervisor.start_child(sup, supervisor(Sequence.SubSupervisor, [stash]))
- end
15 def init(_) do
- supervise [], strategy: :one_for_one
- end
- end
report erratum • discuss
Supervisors and Workers • 235
On line 4 we start up the supervisor. This automatically invokes the init callback. This in turn calls supervise, but passes in an empty list. The supervisor
is now running but has no children.
At this point, OTP returns control to our start_link function, which then calls
the start_workers function. This starts the stash worker, passing it the initial
number. We get back a status of (:ok) and a PID. We then pass the PID to the
subsupervisor.
This subsupervisor is basically the same as our very first supervisor—it simply
spawns the sequence worker. But instead of passing in a current number, it
passes in the stash’s PID.
otp-supervisor/2/sequence/lib/sequence/sub_supervisor.ex
defmodule Sequence.SubSupervisor do
use Supervisor
def start_link(stash_pid) do
{:ok, _pid} = Supervisor.start_link(__MODULE__, stash_pid)
end
def init(stash_pid) do
child_processes = [ worker(Sequence.Server, [stash_pid]) ]
supervise child_processes, strategy: :one_for_one
end
end
The sequence worker has two changes. First, when it is initialized it must get
the current number from the stash. Second, when it terminates it stores the
then-current number back in the stash. To make these changes, we’ll override
two more GenServer callbacks: init and terminate.
otp-supervisor/2/sequence/lib/sequence/server.ex
defmodule Sequence.Server do
use GenServer
#####
# External API
def start_link(stash_pid) do
{:ok, _pid} = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
end
def next_number do
GenServer.call __MODULE__, :next_number
end
def increment_number(delta) do
GenServer.cast __MODULE__, {:increment_number, delta}
end
Chapter 18. OTP: Supervisors • 236
report erratum • discuss
#####
# GenServer implementation
def init(stash_pid) do
current_number = Sequence.Stash.get_value stash_pid
{ :ok, {current_number, stash_pid} }
end
def handle_call(:next_number, _from, {current_number, stash_pid}) do
{ :reply, current_number, {current_number+1, stash_pid} }
end
def handle_cast({:increment_number, delta}, {current_number, stash_pid}) do
{ :noreply, {current_number + delta, stash_pid}}
end
def terminate(_reason, {current_number, stash_pid}) do
Sequence.Stash.save_value stash_pid, current_number
end
end
The stash itself is trivial:
otp-supervisor/2/sequence/lib/sequence/stash.ex
defmodule Sequence.Stash do
use GenServer
#####
# External API
def start_link(current_number) do
{:ok,_pid} = GenServer.start_link( __MODULE__, current_number)
end
def save_value(pid, value) do
GenServer.cast pid, {:save_value, value}
end
def get_value(pid) do
GenServer.call pid, :get_value
end
#####
# GenServer implementation
def handle_call(:get_value, _from, current_value) do
{ :reply, current_value, current_value }
end
def handle_cast({:save_value, value}, _current_value) do
{ :noreply, value}
end
end
report erratum • discuss
Supervisors and Workers • 237
And finally, our top-level module has to start the top-level supervisor:
otp-supervisor/2/sequence/lib/sequence.ex
defmodule Sequence do
use Application
def start(_type, _args) do
➤ {:ok, _pid} = Sequence.Supervisor.start_link(123)
end
end
Let’s work through what is going on here.
• We start the top-level supervisor, passing it an initial value for the counter.
It starts up the stash worker, giving it this number. It then starts the
subsupervisor, passing it the stash’s PID.
• The subsupervisor in turn starts the sequence worker. This goes to the
stash, gets the current value, and uses that value and the stash PID as
its state. The next_number and increment_number functions are unchanged
(except they receive the more complex state).
• If the sequence worker terminates for any reason, GenServer calls its terminate function. It stores its current value in the stash before dying.
• The subsupervisor will notice that a child has died. It will restart the child,
passing in the stash PID, and the newly incarnated worker will pick up
the current value that was stored when the previous instance died.
At least that’s the theory. Let’s try it:
$ iex -S mix
Compiling 6 files (.ex)
Generated sequence app
iex> Sequence.Server.next_number
123
iex> Sequence.Server.next_number
124
iex> Sequence.Server.increment_number 100
:ok
iex> Sequence.Server.next_number
225
iex> Sequence.Server.increment_number "cause it to crash"
:ok
iex>
14:35:07.337 [error] GenServer Sequence.Server terminating
Last message: {:"$gen_cast", {:increment_number, "cause it to crash"}}
State: {226, #PID<0.70.0>}
** (exit) an exception was raised:
** (ArithmeticError) bad argument in arithmetic expression
(sequence) lib/sequence/server.ex:32: Sequence.Server.handle_cast/2
Chapter 18. OTP: Supervisors • 238
report erratum • discuss
(stdlib) gen_server.erl:599: :gen_server.handle_msg/5
(stdlib) proc_lib.erl:239: :proc_lib.init_p_do_apply/3
iex> Sequence.Server.next_number
226
iex> Sequence.Server.next_number
227
Even though we crashed our sequence worker, it got restarted and the state
was preserved. Now we begin to see how careful supervision is critical if we
want to write reliable applications
```




















```
Following the definition of start_link, the next two functions are the external
API to issue call and cast requests to the running server process.
We’ll also use the name of the module as our server’s registered local name
(hence the name: __MODULE__ when we start it, and the __MODULE__ parameter
when we use call or cast).
otp-server/2/sequence/lib/sequence/server.ex
defmodule Sequence.Server do
use GenServer
#####
# External API
➤
 def start_link(current_number) do
GenServer.start_link(__MODULE__, current_number, name: __MODULE__)
end
➤
 def next_number do
GenServer.call __MODULE__, :next_number
end
➤
 def increment_number(delta) do
GenServer.cast __MODULE__, {:increment_number, delta}
end
#####
# GenServer implementation
def handle_call(:next_number, _from, current_number) do
{ :reply, current_number, current_number+1 }
end
def handle_cast({:increment_number, delta}, current_number) do
{ :noreply, current_number + delta}
end
def format_status(_reason, [ _pdict, state ]) do
[data: [{'State', "My current state is '#{inspect state}', and I'm happy"}]]
end
end

```








```
otp-supervisor/2/sequence/lib/sequence/server.ex
defmodule Sequence.Server do
use GenServer
#####
# External API
def start_link(stash_pid) do
{:ok, _pid} = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
end
def next_number do
GenServer.call __MODULE__, :next_number
end
def increment_number(delta) do
GenServer.cast __MODULE__, {:increment_number, delta}
end
report Supervisors and Workers
 • 237
#####
# GenServer implementation
def init(stash_pid) do
current_number = Sequence.Stash.get_value stash_pid
{ :ok, {current_number, stash_pid} }
end
def handle_call(:next_number, _from, {current_number, stash_pid}) do
{ :reply, current_number, {current_number+1, stash_pid} }
end
def handle_cast({:increment_number, delta}, {current_number, stash_pid}) do
{ :noreply, {current_number + delta, stash_pid}}
end
def terminate(_reason, {current_number, stash_pid}) do
Sequence.Stash.save_value stash_pid, current_number
end
end

```










  ```
  We’ll also use the name of the module as our server’s registered local name
(hence the name: __MODULE__ when we start it, and the __MODULE__ parameter
when we use call or cast).
otp-server/2/sequence/lib/sequence/server.ex
defmodule Sequence.Server do
use GenServer
#####
# External API
➤ def start_link(current_number) do
GenServer.start_link(__MODULE__, current_number, name: __MODULE__)
end
➤ def next_number do
GenServer.call __MODULE__, :next_number
end
➤ def increment_number(delta) do
GenServer.cast __MODULE__, {:increment_number, delta}
end
#####
# GenServer implementation
def handle_call(:next_number, _from, current_number) do
{ :reply, current_number, current_number+1 }
end
def handle_cast({:increment_number, delta}, current_number) do
{ :noreply, current_number + delta}
end
def format_status(_reason, [ _pdict, state ]) do
[data: [{'State', "My current state is '#{inspect state}', and I'm happy"}]]
end
end

  ```