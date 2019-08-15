# Elixir course lesson №13

# Supervisor

Elixir's supervisors are specific modules in Elixir which give the ability to monitor many processes which will be executed at the start of the whole application passing some initial data structure to them.
After that, the supervisor takes care of all of it's 'child' processes which he supervises. If they fail for some reason he makes sure that they are restarted in a state that we have defined as stable. 

This leads to developing common approach in making an elixir application, which is "let it crash" / "fail fast". This aproach is so common due to the fact that restarting an elixir process is rather cheap operation. 

There are three strategies for supervisor organisation if a child process stops/crashes.

```
one_for_one - only that child is being restarted
rest_for_one - that one and all bellow it in the list of childs are being restarted.
one_for_all - all are being restarted no matter the order
```

In order an elixir to implement a supervisor, we shall execute the command `mix new counter --sup` which will generate us a new Elixir mix project, with an additional file **application.ex** where the Supervisor is defined.



#### DynamicSupervisor

https://hexdocs.pm/elixir/DynamicSupervisor.html

Dyanmic supervisor is a supervisor whose children are added dynamically during the applications runtime. It's only strategy is `one_for_one`.

How to define a dynamic supervisor:

```
children = [
  {DynamicSupervisor, strategy: :one_for_one, name: MyApp.DynamicSupervisor}
]

Supervisor.start_link(children, strategy: :one_for_one)
```

How to add a new child during runtime in the dynamic supervisor:

```
{:ok, agent1} = DynamicSupervisor.start_child(MyApp.DynamicSupervisor, {Agent, fn -> %{} end})
Agent.update(agent1, &Map.put(&1, :key, "value"))
Agent.get(agent1, & &1)
#=> %{key: "value"}

{:ok, agent2} = DynamicSupervisor.start_child(MyApp.DynamicSupervisor, {Agent, fn -> %{} end})
Agent.get(agent2, & &1)
#=> %{}

DynamicSupervisor.count_children(MyApp.DynamicSupervisor)
#=> %{active: 2, specs: 2, supervisors: 0, workers: 2}
```

