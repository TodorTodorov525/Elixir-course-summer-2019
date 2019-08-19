# Elixir course lesson №9

## Writing integrated documentation (doc, moduledoc, spec, typedoc) 


#### doc
It is used for describing a function.

Example:
```
@doc """
  Give the function a number.
"""
def test_require(a) when Integer.is_odd(a) == true do
  BigTask.Checker.check(a)
end
```

#### moduledoc

A documentation for the whole module.
```
@moduledoc """
This module is for calculating integers.
"""

@doc """
  Give the function an odd number.
"""
def test_require(a) when Integer.is_odd(a) == true do
  BigTask.Checker.check(a)
end
```
#### spec
The parameter type which the function expects and the return type.
```
@spec test_require(integer) :: integer
```

The compiler ignores the specifications. The function can still be called with the wrong parameters,

There are basically two main benefits to declaring specifications and using custom types.

Firstly, it acts as documentation. It’s much easier to read and understand code if you know what the types are. Even the best named arguments and functions can be ambiguous when you are trying to get to grips with new code. Function specifications and custom types make it explicitly clear as to what is going on, and tools like ExDoc can take advantage of your specifications to show this kind of detail in the documentation that is produced from your code.

Secondly, you can use Dialyzer, which is an Erlang static analysis tool to find discrepancies or possible bugs in your code. In Elixir, we can use dialyxir to make it easier to work with Dialyzer. Whilst using Dialyzer does not guarantee that you will find all bugs and errors in your code, you are sure to get some benefit from writing specs and using a static analysis tool.

#### typedoc

It is used for writing documentations of all of the custom types defined.
```
@typedoc """
  Documentation of a new type.
"""
@type t :: %BigTask.Calculator{first: integer, last: integer}
```


#### How to generate the documentation of your mix project

```
 1. Add this dependency - {:ex_doc, github: "elixir-lang/ex_doc"}
 2. Run mix deps.get
 3. Run mix docs
 4. Open any of the generated .html files
```