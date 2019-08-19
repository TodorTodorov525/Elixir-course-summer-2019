# Elixir course lesson №10

## Processes, agents, tasks

Concurrency is the composition of independently executing things, typically functions.
Parallelism is the simultaneous execution of multiple things, possibly related, possibly not.
Once we are able to split our problem into sub-tasks, and make it concurrent, we are then also able to take advantage of multiple cores and run the different sub-tasks in parallel.

### Process

Elixir programs are made by many processes. The language's architecture provides the ability to create millions of processes on a single machine. They are not OS processes, they are much more lightweight, a single elixir process uses around 1-2KB memory. Their use is a common approach when building fast and scalable applications.

A process is made by the function `spawn`. If it is successful an unique process identifier(pid) is returned. Which pid can then be used for inter process communication and remote calls.

Example:

```
 def add(a, b) do
    IO.puts(a + b)
 end
iex(83)> spawn(Chain, :add, [2,300]) #the first argument is the module name, the second is the function name, the third are the parameters passed to the function
302
#PID<0.329.0>
```

The pid of the current process can be found by using the function `self`. Calling it in iex returns the pid of the current Elixir shell.

Example:

```
iex(1)> self()
#PID<0.26.0>
```

Processes in Elixir rely on messages for communication with one another. The function that implements the sending of a message is `send` and the code block used for handling different messages is `receive do` if a message is not handled, the execution of the code continues uninterrupted.

Example:

```
def report() do
  receive do
    "cat" -> IO.puts("mind your language")
    msg -> IO.puts("Received #{msg}")
  end
  report()
end

iex(10)> pid = spawn(Chain, :report, [])
#PID<0.211.0>
iex(11)> send(pid, "cat")
mind your language
"cat"
iex(12)> send(pid, "dog")
Received dog
"dog"
```

Using the `spawn` function allows us to create a process in a way that we will not be able to know when the process is finished. Luckily Elixir provides a function for creating linked processes called `spawn_link` so that two linked processes will receive exit notifications from one another.

Example:

```
iex(1)> spawn fn -> raise "oops" end
#PID<0.87.0>
iex(2)>
11:27:23.276 [error] Process #PID<0.87.0> raised an exception
** (RuntimeError) oops
    (stdlib) erl_eval.erl:668: :erl_eval.do_apply/6
iex(2)> spawn_link fn -> raise "oops" end

11:27:28.341 [error] Process #PID<0.89.0> raised an exception
** (RuntimeError) oops
    (stdlib) erl_eval.erl:668: :erl_eval.do_apply/6
** (EXIT from #PID<0.85.0>) shell process exited with reason: an exception was raised:    |
    ** (RuntimeError) oops                                                                |
        (stdlib) erl_eval.erl:668: :erl_eval.do_apply/6                                   |

```


An elixir process is being terminated after it receives a message, in order to keep it alive, a recursive call after the receive do block must be implemented.

Example:

```
def report() do
  receive do
    "cat" -> IO.puts("mind your language")
    msg -> IO.puts("Received #{msg}")
  end
  report()  #keeps the process alive which means that it will listen all the time for a new message
end
```

Process can be killed by the function `Process.exit`, to check if it is alive, `alive?` function is used.

```
iex(2)> p = spawn(fn -> "x " end)
#PID<0.94.0>
iex(3)> Process.exit(p, :kill)
true
iex(4)> Process.alive?(p)
false
```


### Agent

Agents are an abstraction around background processes maintaining state. We can access them from other processes within our application and node. The state of our Agent is set to our function’s return value:

```
iex> {:ok, agent} = Agent.start_link(fn -> [1, 2, 3] end)
{:ok, #PID<0.65.0>}

iex> Agent.update(agent, fn (state) -> state ++ [4, 5] end)
:ok

iex> Agent.get(agent, &(&1))
[1, 2, 3, 4, 5]
```

To add it in your Elixir module you must add the command `use Agent` and to specify whether the agent should be restarted if it is being closed and a exact time for it to live before being shut down.

Example:

```
defmodule AgentTest do
  use Agent, restart: :transient, shutdown: 10_000

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def increment do
    Agent.update(__MODULE__, &(&1 + 1))
  end
end
```


### Task

https://hexdocs.pm/elixir/Task.html

Tasks are meant to execute one particular action throughout their lifetime, and are the Elixir's implementation of asynchronic processes. To create an asynchronic processes the `Task.async` function must be called. When invoked, a new process will be created, linked and monitored by the caller. Once the task action finishes, a message will be sent to the caller with the result, but in order to read the message the function `Task.await` must be used.
It is important ot mention that async tasks link the caller and the spawned process. This means that, if the caller crashes, the task will crash too and vice-versa. This is on purpose: if the process meant to receive the result no longer exists, there is no purpose in completing the computation. If this is not desired, use Task.start/1 or consider starting the task under a `Task.Supervisor` using `async_nolink` or `start_child`.

`Task.yield` is an alternative to await/2 where the caller will temporarily block, waiting until the task replies or crashes. If the result does not arrive within the timeout, it can be called again at a later moment. This allows checking for the result of a task multiple times. If a reply does not arrive within the desired time, `Task.shutdown` can be used to stop the task.

Example:

```
def add(a, b) do
  Process.sleep(40000)
  IO.puts "40000 milliseconds elapsed"
  a+b
end
iex(17)> x = Task.async(Chain, :add, [1,2])
%Task{
  owner: #PID<0.167.0>,
  pid: #PID<0.321.0>,
  ref: #Reference<0.1499057113.2386296833.72087>
}
iex(18)> Task.await(x, 50000)
40000 milliseconds elapsed
3
```

# Classwork

1. Create chain of processes.




# Homework

1. Rewrite the exercise with the football teams, so that it uses an agent.

2. Create a module or a new mix project which will have to make requests to https://docs.openaq.org
```
There must be a function to which a country name should be passed as an argument. 
On the screen there should be all of the current measurements in that country, 
and the city with the highest and lowest measurement value. 
Processes, tasks or agents shall be used. The code structure and the way of implementation are fluid.
For ease use these dependencies:
https://hex.pm/packages/httpoison - for http requests
https://hex.pm/packages/jason - for jason encoding and decoding

*You can use any dependency of your liking as long as it has the needed functionality.*
*The lack of usage of dependencies can be used only when new free of dependency implementation is wanted by the student.*

Additional literature: https://www.poeticoding.com/spawning-processes-in-elixir-a-gentle-introduction-to-concurrency/
```

3.
```
1. Create a new module - Stack
2. Let stack has a function - start/0
3. Let Stack has another function - loop/1, that can receive any message, will print "Unsupported
message" and returns itself with the same argument
4. The function start/0 should spawn the function loop in a separate process with an empty list as
the argument, and will return the pid of the new process
5. Let loop/1 receive a message in the form of ":show" and it will print out the contents of the
argument
6. Make it so that loop/1 can receive a message in the form of {:push, item}, and in that case will
call itself with the "item" inserted at the beginning of its argument
E.g if loop/1 has an empty list as the argument, and receives the message {:push, "test"} it should
call loop(["test"])
If it then receives a message in the form of {:push, "alabala"} it should call loop(["alabala", "test"])
Then if it receives {:something} it should call loop(["alabala", "test"])
7. Create a function push/2 that receives a pid and an item and sends to the pid a message in the
form of {:push, item}
8. Let loop be able to receive message in the form of {:pop, pid}. In that case it should send to the
pid the first item in the current list. If no items are in the list, it should send {:error, "No items in
the list"}. If there are items, after returning the first one, it should call itself with the reduced list.
9. Create a function pop/1, that receives a pid, and sends it {:pop, <its-own-pid>}. Then it waits to
receive a message, and if there are no errors, it returns the received item.
10. Create a separate function for each message
```