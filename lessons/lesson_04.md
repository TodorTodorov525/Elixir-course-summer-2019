# Elixir course lesson №4

## Mix, pipe operator, Enum

### Mix


Mix is a build automation tool. It provides a set of tools for creating, testing and building applications. It will also manage the imported dependencies, if you have installed Elixir you already have mix (it comes with the language).
Mix is used for all elixir related processes that precede the "deployment to production". Creating a new project is done by the command `mix new project_name`. After executing a folder is created. It contains the main script `mix.exs`, a file for styling your code `formater.exs` which usually executes `mix format`. There are also several folders, `_build` contains binary compiled files of the imported libraries, `config` contains a file for specifying additional configurations to our project, in `lib` are all of our **Elixir modules** we have created(the ones from the dependencies are in `_build`). There is also a `test` folder in which we can write our own test modules, mix is shipped with `ExUnit` - a testing framework. In the current lesson an object of our attention will be the `lib` folder and the **Elixir module's structure**.

#### Elixir module

A module is being defined by the `defmodule` keyword, succeeded by the module name and the `do` keyword, an elixir module always ends with an `end`. The Elixir's coding standards suggest separating each module of the project in a separate file, the Elixir file modules have an `.ex` extention. These files are where Elixir functions being written.

```
### Elixir module
defmodule ModuleName do
  code in module
end
```

 The syntax for Elixir function is:

```
### Elixir function
def function_name do
  body of function
end
```

To "run" an Elixir project, the command `iex -S mix` must be executed in the project's folder. An interactive shell will be started, which is the same as the `iex` shell we used before, with the only diference comming from the modules that are being created. Calling a function from a module is done by writing the module name "." and the function name.

Example:

```
iex(1)> TestProject.hello
:world
iex(2)> TestProject.sum(1,2)
3
```

Elixir allows the definition of private functions. This is done by the `defp` keyword. Private function can be accessed only through the module they are defined.

Example:

```
### Elixir private function
defp private_function(param) do
  body of function
end
```

Elixir also gives the ability to set a default values for the arguments of a function. They are used then no parameters are passed.


Example:

```
def print_list(list \\ [1, 2, 3]) do
  list
end

iex(1)> TestProject.print_list()
[1, 2, 3]
iex(2)> TestProject.print_list(["a", "b", "c"])
["a", "b", "c"]
```


### Pipe operator "|>"

The pipe operator is a very important operator in Elixir and it is used for optimizing the code's syntax. It is used in every Elixir project. The operations using that operator contains a "left side" the operator and a "right side". "Piping" means that the **output of the left side is passed as a first argument on the right side**. If on the left side is a variable, the variable itself is passed to the right side.

Example:

```
###Example module using the pipe operator
defmodule ExampleSort do
  def main(input) do
    input
    |> convertToList
    |> reverseList
  end

  def convertToList(input) do
    String.split(input, "", trim: true)
  end

  def reverseList(input) do
    Enum.reverse(input)
  end
end
ExampleSort.main("asdf")
["f", "d", "s", "a"]
```



### Enum

Enum is a module in Elixir, which conatins a wide range of functions for operating with enumerables (maps, lists, ranges).
https://hexdocs.pm/elixir/Enum.html

Some of the functions are used for manipulating an existing enumerable iteratively(element by element). 

Example:

```
https://hexdocs.pm/elixir/Enum.html#map/2

iex(9)> Enum.map(%{1 => 2, 3 => 4}, fn {k, v} -> %{k => v * 10} end) 
[%{1 => 20}, %{3 => 40}]
```

# Exercises


1. You have a map with the following structure:
%{first_name: "Alice", second_name: "Hemingway", age: 20}
Write a function, that when receives that map, returns the string “Hello, Alice Hemingway!”

2. Create a function “length_of_tuple”, that returns the number of elements in a tuple.
If they are more than 4, return the string “Shouldn’t you use list?”

3. Given a list of years: `[1994, 600, 1965, 0, 1, 2019, 2008, 1921, 1936, 1414, 2000, 1992, 2004]`, using `Enum.filter` remove every year, that is not from the 21st century

4. You have the numbers from 1 to 100, using pipe, select all the even number, excluding 100. Then from that list, remove the numbers divisible by 3. Then multiply every second number by 100. Use ranges!

5. Given a list: `[%{name: "Donald", age: 10}, %{name: "Jerry", age: 21}, %{name: "Tom", age: 24}]` remove everyone, that should not be allowed to drink alcohol


# Homework 

- Create a mix project
- Create an `.ex` file called `homework0304.ex`
- In it write your solutions to the following tasks.
- Push them into a github repo.
- If it is a private one, assign me as a collaborator

1. Write a function which takes one argument. If the argument is a list, print on the screen `"The argument is a list, its first agument is #{arg1}"`, where `arg1` is the first element of the list. If the argument is a tuple, print "The argument is a tuple" transform it to a list and print on the screen "The argument is a list, its first argument is #{arg1}" without writing another IO function. Handle the empty list appropriately. If it is a map, transform it into a list and print the same message. For ease the map structure should be %{a: 1}.

!!! Bonus: Make the function to work with maps, whose keys are strings.  %{"a" => 1}

2. The nested list [1, [2, 3], 4] is given.
Exercises:
- match `1` from the nested_list
- match `2` from the nested_list

3. Write a function that adds 1 to every element in the list. The elements are numeric values (integer, float).

4. Write a function that calculates the perimeter of a triangle. It should work if the side's lengths are passed as separate arguments, in a tuple, in a list, or in a map.
Example of map structure: %{a: value_a, b: value_b, c: value_c}


5. Given a list `[%{name: “Tom”, age: 14}, %{name: “Jerry”, age: 21}, %{name: “Donald”, age: 18}]`, return the following list: `[“Tom: 14 years old”, “Jerry: 21 years old”, “Donald: 18 years old”]`

6. Given the list from the previous task, made an additional case for when the age is “1”, then it should output “<name>: 1 year old”

7. Given the following list: [“An example sentence”, “Another sentence”, “Third sentence”], remove every sentence that has at least one “a”