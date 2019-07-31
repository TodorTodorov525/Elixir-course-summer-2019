# Elixir course lesson №8

## Module inheritance (Alias, Import, Require, Use) | Struct 

There are numerous ways to implement functionality from one module to another in Elixir. Depending on which type of inheritance and code reuse is needed there are different module inheritance types defined:

```
Alias
Import
Require
Use
```

'Alias' is used when we want to shorten a module name. To make a module available 'require' is needed. To make all functions of a particular module available 'import' is used and if it some external functionaltiy needed 'use' is being used.

Combination between inheritances is also available:

```
# Ensure the module is compiled and available, import functions
# from Foo.Bar so they can be called without the `Foo.Bar` prefix
# (Combo of require + import)
require Foo.Bar 

# Ensure the module is compiled and available, import functions
# from Foo.Bar so they can be called with only the `B` prefix
# (Combo of require + alias)
require Foo.Bar, as: B
```

#### Alias

The alias directive creates an alias for a module. One obvious use is to cut
down on typing.
```
defmodule Example do
  def compile_and_go(source) do
  alias My.Other.Module.Parser, as: Parser
  alias My.Other.Module.Runner, as: Runner
  # In the remaining module definition Parser and Runner expand to My.Other.Module.Parser and My.Other.Module.Runner
  source
  |> Parser.parse()
  |> Runner.execute()
  end
end
```


#### Import

The import directive brings a module’s functions and/or macros into the current
scope. If you use a particular module a lot in your code, import can cut down
the clutter in your source files by eliminating the need to repeat the module
name time and again.
For example, if you import the flatten function from the List module, you’d be
able to call it in your code without having to specify the module name.

```
defmodule Example do
  def func1 do
    List.flatten [1,[2,3],4]
  end
  def func2 do
    import List, only: [flatten: 1]
    flatten [5,[6,7],8]
  end
end
```

The optional second parameter lets you control which functions or macros
are imported. You write only: or except:, followed by a list of name: arity pairs. It
is a good idea to use import in the smallest possible enclosing scope and to
use only: to import just the functions you need.
```
import List, only: [ flatten: 1, duplicate: 2 ]
```
import also supports :macros and :functions to be given to :only. For example, to import all macros, one could write:

```
import Integer, only: :macros
```
Or to import all functions, you could write:

```
import Integer, only: :functions
```
Note that import is lexically scoped too. This means that we can import specific macros or functions inside function definitions:

```
defmodule Math do
  def some_function do
    import List, only: [duplicate: 2]
    duplicate(:ok, 10)
  end
end
```

In the example above, the imported List.duplicate/2 is only visible within that specific function. duplicate/2 won’t be available in any other function in that module (or any other module for that matter).

Note that importing a module automatically requires it.


#### Use


Although not a directive, use is a macro tightly related to require that allows you to use a module in the current context. The use macro is frequently used by developers to bring external functionality into the current lexical scope, often modules. Let us understand the use directive through an example −

```
defmodule Example do 
   use Feature, option: :value 
end 
Use is a macro that transforms the above into −

defmodule Example do
   require Feature
   Feature.__using__(option: :value)
end
```

The use Module first requires the module and then calls the __using__ macro on Module. Elixir has great metaprogramming capabilities and it has macros to generate code at compile time. The __using__ macro is called in the above instance, and the code is injected into our local context. The local context is where the use macro was called at the time of compilation.

The use macro is frequently used as an extension point. This means that, when you use a module FooBar, you allow that module to inject any code in the current module, such as importing itself or other modules, defining new functions, setting a module state, etc.

For example, in order to write tests using the ExUnit framework, a developer should use the ExUnit.Case module:

```
defmodule AssertionTest do
  use ExUnit.Case, async: true

  test "always pass" do
    assert true
  end
end
```

Behind the scenes, use requires the given module and then calls the __using__/1 callback on it allowing the module to inject some code into the current context. Some modules (for example, the above ExUnit.Case, but also Supervisor and GenServer) use this mechanism to populate your module with some basic behaviour, which your module is intended to override or complete.

Generally speaking, the following module:
```
defmodule Example do
  use Feature, option: :value
end
is compiled into

defmodule Example do
  require Feature
  Feature.__using__(option: :value)
end
```
Since use allows any code to run, we can’t really know the side-effects of using a module without reading its documentation. For this reason, import and alias are often preferred, as their semantics are defined by the language.


Consider the following:
```
defmodule ModA do
  defmacro __using__(_opts) do
    IO.puts "You are USING ModA"
  end

  def moda() do
    IO.puts "Inside ModA"
  end
end

defmodule ModB do
  use ModA

  def modb() do
    IO.puts "Inside ModB"
    moda()     # <- ModA was not imported, this function doesn't exist
  end
end
This will not compile as ModA.moda() has not been imported into ModB.

The following will compile though:

defmodule ModA do
  defmacro __using__(_opts) do
    IO.puts "You are USING ModA"
    quote do          # <--
      import ModA     # <--
    end               # <--
  end

  def moda() do
    IO.puts "Inside ModA"
  end
end

defmodule ModB do
  use ModA

  def modb() do
    IO.puts "Inside ModB"
    moda()            # <-- all good now
  end
end
As when you used ModA it generated an import statement that was inserted into ModB.
```

#### Require

You require a module if you want to use any macros it defines. This ensures that the macro definitions are available when your code is compiled. 

Elixir provides macros as a mechanism for meta-programming (writing code that generates code).

Macros are chunks of code that are executed and expanded at compilation time. This means, in order to use a macro, we need to guarantee its module and implementation are available during compilation. This is done with the require directive:

```
iex> Integer.is_odd(3)
** (CompileError) iex:1: you must require Integer before invoking the macro Integer.is_odd/1
iex> require Integer
nil
iex> Integer.is_odd(3)
true
```
In Elixir, Integer.is_odd/1 is defined as a macro so that it can be used as a guard. This means that, in order to invoke Integer.is_odd/1, we need to first require the Integer module.

In general a module does not need to be required before usage, except if we want to use the macros available in that module. An attempt to call a macro that was not loaded will raise an error. Note that like the alias directive, require is also lexically scoped.

#### Struct

Structs are extensions built on top of maps that provide compile-time checks and default values. They are also the way to implement a custom type for a module.

Defining structs
To define a struct, the defstruct construct is used:

```
iex> defmodule User do
...>   defstruct name: "John", age: 27
...> end
```
The keyword list used with defstruct defines what fields the struct will have along with their default values.

Structs take the name of the module they’re defined in. In the example above, we defined a struct named User.

We can now create User structs by using a syntax similar to the one used to create maps (if you have defined the struct in a separate file, you can compile the file inside IEx before proceeding by running c "file.exs"; be aware you may get an error saying the struct was not yet defined if you try the below example in a file directly due to when definitions are resolved):
```
iex> %User{}
%User{age: 27, name: "John"}
iex> %User{name: "Jane"}
%User{age: 27, name: "Jane"}
Structs provide compile-time guarantees that only the fields (and all of them) defined through defstruct will be allowed to exist in a struct:

iex> %User{oops: :field}
** (KeyError) key :oops not found in: %User{age: 27, name: "John"}
```

Structs are some kind of wrapper around maps which provides additional functionality to the last.

Let’s update our John’s example using a Struct. To define a Struct we need to define a Module, which would become the name of that structure. Then we use defstruct keyword followed by available keys.

```
iex> defmodule Person do
...>   defstruct first_name: "", last_name: "", age: nil, adult: true
...> end
{:module, Person,
 <<70, 79, 82, 49, 0, 0, 8, 92, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 0, 234,
   0, 0, 0, 22, 13, 69, 108, 105, 120, 105, 114, 46, 80, 101, 114, 115, 111,
   110, 8, 95, 95, 105, 110, 102, 111, 95, 95, ...>>,
 %Person{adult: true, age: nil, first_name: "", last_name: ""}}

iex> john = %Person{first_name: "John", last_name: "Doe", age: 35}
%Person{adult: true, age: 35, first_name: "John", last_name: "Doe"}

iex> bob = %Person{first_name: "Bob", age: 40}

%Person{adult: true, age: 40, first_name: "Bob", last_name: ""}
```
By defining a Struct in the following way, we are specifying the fields this structure has. That being said we are defining the particular structure of the attributes and we are not allowed to use keys which were not specified.
```
iex> alice = %Person{first_name: "Alice", address: "White Hall Str. 503"}
** (KeyError) key :address not found in: %Person{adult: true, age: nil, first_name: "Alice", last_name: ""}
    (stdlib) :maps.update(:address, "White Hall Str. 503", %Person{adult: true, age: nil, first_name: "Alice", last_name: ""})
    iex: anonymous fn/2 in Person.__struct__/1
    (elixir) lib/enum.ex:1811: Enum."-reduce/3-lists^foldl/2-0-"/3
    expanding struct: Person.__struct__/1
    iex: (file)
```

As soon as a Struct is a Map underneath we can update it using the same approach:
```
iex> john
%Person{adult: true, age: 35, first_name: "John", last_name: "Doe"}

iex> john = %Person{ john | age: 36 }
%Person{adult: true, age: 36, first_name: "John", last_name: "Doe"}
Following code also works fine. Even if it might look a little bit weird:

iex> john = Map.put(john, :age, 37)
%Person{adult: true, age: 37, first_name: "John", last_name: "Doe"}
However if we try to use Map.put_new/3 or Map.delete/2 here (which is not permitted) we would get following result:

iex> Map.put_new(john, :title, "Mr.")
%{__struct__: Person, adult: true, age: 37, first_name: "John",
  last_name: "Doe", title: "Mr."}
  
iex> Map.delete(john, :adult)
%{__struct__: Person, age: 37, first_name: "John", last_name: "Doe"}
```


One of the additional advantages of the Struct over the Map is that you can define functions for the Struct. That is probably the reason why it’s wrapped into the module.

```
iex> defmodule Person do
...>   defstruct first_name: "", last_name: "", age: nil
...>
...>   def has_discount?(person) do
...>     person.age != nil && person.age < 18
...>   end
...>
...>   def full_name(person) do
...>     "#{person.first_name} #{person.last_name}"
...>   end
...> end
{:module, Person,
 <<70, 79, 82, 49, 0, 0, 11, 192, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 1, 89,
   0, 0, 0, 35, 13, 69, 108, 105, 120, 105, 114, 46, 80, 101, 114, 115, 111,
   110, 8, 95, 95, 105, 110, 102, 111, 95, 95, ...>>, {:full_name, 1}}

iex> john = %Person{first_name: "John", last_name: "Doe", age: 35}
%Person{age: 35, first_name: "John", last_name: "Doe"}

iex> Person.has_discount?(john)
false

iex> Person.full_name(john)
"John Doe"
```

##### defstruct with @enforce_keys
Whenever you want to model your data with maps, you should also consider struct because struct is a tagged map which offers compile time checks on the key and allows us to do run-time checks on the struct’s type, for example:

you can’t create a struct with field that is not defined. In the following example you can also see how we apply the first trick we just learned.

```
defmodule Fun.Game do
  alias __MODULE__
  defstruct(
    time: nil,
    status: :init
  )

  def new() do
    %Game{step: 1}
  end
end

iex> IO.inspect Fun.Game.new()
iex> ** (KeyError) key :step not found in: %{__struct__: Fun.Game, status: :init, time: nil}
```
However, sometimes you want to ensure that some fields are present whenever you create a new struct. Fortunately, Elixir provides @enforce_keys module attribute for that:
```
defmodule Fun.Game do
  @enforce_keys [:status]

  alias __MODULE__
  defstruct(
    time: nil,
    status: :init
  )

  def new() do
    %Game{}
  end
end

iex> Fun.Game.new()
iex> ** (ArgumentError) the following keys must also be given when building struct Fun.Game: [:status]
```
Based on the result, you can see that in this case we can’t rely on the default value of status, we need to specify its value when we create a new Game:
```
def new(status) do
  %Game{status: status}
end

iex> Fun.Game.new(:won)
iex> %Fun.Game{status: :won, time: nil}
```



There is also a way of defining the types for each field of the struct. 

```
@type t() :: %__MODULE__{
        name: String.t(),
        age: integer(),
        phone: String.t() | nil
      }
```


# Homework 

1. Write a few modules. The first should have functions which will implement the basic operations for numbers (+, -, /, *) and strings (concatenation). The second should implemen a checker - module which chas functions for validating the parameter types and calling the printer module. The third module isthe printer module, which implements a function for printing information about the variable and its type and the operation requested.
Use all of the module inheritances one way or another.