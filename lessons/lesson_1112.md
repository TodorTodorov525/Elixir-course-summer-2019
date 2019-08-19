# Elixir course lesson №11

## GenServer

https://hexdocs.pm/elixir/GenServer.html

GenServer is the Elixir's abstraction of an client - server implementation. The GenServer itself is a single process(in terms of OS processes), but it can be constructed by many asynchronic processes which will be working concurrently. Racing each other to communicate with the main(server) process.
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

Then we can implement functionality which can update the GenServer's state. In order for it to be the only one which will be executed by the user at a single moment of time we use the `GenServer.call` method specifying the atom `:cal` as a marker for expressing what are we 'calling'.
```
def cal() do
    GenServer.call(__MODULE__, :cal)
end
```

And the server callback which shall return a reply to the server we specify a handle to an exact marker, and then we send a reply, whose second parameter is the value/message that will be printed as a result of that whole synchronous call in the terminal. And as a third argument the new value of the state(it can be the old one if we haven't made any changes to the value).
```
def handle_call(:cal, from, state) do
  {:reply, :syn, state ++ [1]}
end
```

We can also implement a functionality which will make an asynchronous call to the server, in order to do that we can use `GenServer.cast` also specifying an atom as a marker is needed. In the example the marker is `cas`. It won't block the IO, it will be executed in background and it is also possible to call multiple to run concurrently.
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

1. Implement a GenServer which shall synchronously add in a state map a key value pair ex: "a" => 1 and asynchronicaly messages in a list which can be accessed through a key named "async". Implement a graceful shutdown and a print. (first part)


2. Implement two GenServers which shall have functionality for passing messages to each other and to themselves. The messages shall be saved in the GenServer's state. (second part)

