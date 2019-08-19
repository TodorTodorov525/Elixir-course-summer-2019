# Elixir course lesson №5

## Operators/Control structures (if, unless cond, case), 'with' comprehension | Simulation of a 'for' loop using interpolation and comprehension | guards

Control structure's flow in general: 
https://cdn1.imggmi.com/uploads/2019/7/17/7e9cb6beeef9756b458bb1e1a746b605-full.jpg


The control structures in elixir are used when one or more conditions need to be specified, and a set of operations must be executed when a condition is met.
Elixir's control structures: 
```
if
unless
cond
case
```
Each one of them has a different use case and will be looked up separately in details.

Decision making structures require that the programmer specifies one or more conditions to be evaluated or tested by the program, along with a statement or statements to be executed if the condition is determined to be true, and optionally, other statements to be executed if the condition is determined to be false.

Following is the general form of a typical decision making structure found in most of the programming language − Elixir provides `if/else` conditional constructs like many other programming languages. It also has a `cond` statement which calls the first true value it finds. `Case` is another control flow statement which uses pattern matching to control the flow of the program.

Elixir, as a functional programming language, normally follows declarative programming paradigm instead of imperative. By defining lots of small independent functions and use some tools Elixir provides us, we will use less of control flow constructions comparing to other languages. Well, maybe comparing to imperative languages.

However, we have tools to control a flow in Elixir and it is always good to know them.


### If

The syntax of an if statement is as follows:
```
if boolean-statement do
  #Code to be executed if condition is satisfied
end
```

If the Boolean expression evaluates to true or success, then the block of code inside the if statement will be executed. If the Boolean expression evaluates to **false or nil**, then the first set of code after the `end` keyword of the given if statement will be executed.


**`if`** flow diagram:
https://cdn1.imggmi.com/uploads/2019/7/17/f5880140a7489fec5208e522aa968744-full.jpg

Example:

```
a = true
if a === true do
  IO.puts "Variable a is true!"
  IO.puts "So this code block is executed"
end
IO.puts "Outside the if statement"
```
The above program will generate the following result: 
```
Variable a is true!
So this code block is executed
Outside the if statement
```

If the opearation in an "if" condition is successful, the code which is being conditioned wll be executed.
Example: 

```
def fun() do
  if(1 - 1) do
    IO.puts("print")
  end
end

iex(1)> TestRpoejct.fun
print
:ok
```


#### "If else" statement

The syntax of an if..else statement is as follows:
```
if boolean-statement do
  #Code to be executed if condition is satisfied
else
  #Code to be executed if condition is not satisfied
end
```

If the Boolean expression evaluates to **`true or success`**, then the block of code inside the `if` statement will be executed. If Boolean expression evaluates to **`false or nil`**, then the code after the `else` keyword of the given if statement will be executed.

`If else` flow diagram:
https://cdn1.imggmi.com/uploads/2019/7/17/3d289e6be5da5e82197113133c16e64e-full.jpg - bad example of an algorithmic structure, the "truthtful/rightful" flow must be the main path

Example:
```
a = false
if a === true do
  IO.puts "Variable a is true!"
else
  IO.puts "Variable a is false!"
end
IO.puts "Outside the if statement"
```
The above program will generate the following result.
```
Variable a is false!
Outside the if statement
```

Another example, showing that successful execution of an arithmetic operation evaluates to a truthful value.
```
def fun2() do
  if(5 + 5) do
    IO.puts("got in if")
  else
    IO.puts("got in else")
  end
end

iex(1)> TestRpoejct.fun2
got in if
:ok
```



### Unless

This control structure implements the opposite logic of `if`. **If the condition is not met, the conditioned code is executed**

Example: 

```
iex(1)> num = 10
10
iex(2)> unless num == 50 do
...(2)> IO.puts "Number is not 50"
...(2)> end
Number is not 50
:ok
```

The syntax of an unless statement is as follows:
```
unless boolean-statement do
  #Code to be executed if condition is false
end
```

If the Boolean expression evaluates to false, then the block of code inside the
`unless` statement will be executed. If the Boolean expression evaluates to true, then the first set of code after the `end` keyword of the given unless statement will be
executed.

Example:
```
a = false
unless a === true do
  IO.puts "Condition is not satisfied"
  IO.puts "So this code block is executed"
end
IO.puts "Outside the unless statement"
```

The above program generates the following result:
```
Condition is not satisfied
So this code block is executed
Outside the unless statement
```

#### "Unless else" statement

An unless..else statement consists of a Boolean expression followed by one or
more statements. This is further followed by an `else` statement with its own block of statements.

The syntax of an `unless..else` statement is as follows:
```
unless boolean-statement do
  #Code to be executed if condition is false
else
  #Code to be executed if condition is true
end
```

If the Boolean expression evaluates to false, then the block of code inside the
`unless` statement will be executed. If the Boolean expression evaluates to true, then the code after the `else` keyword of the given unless statement will be executed.

Example:
```
def fun3 do
  unless(1 == 1) do
    "one is not one"
  else
    "everything is ok, one is one"
  end
end
iex(1)> TestRpoejct.fun3 
"everything is ok, one is one"
```

### Cond

Elixir doesn't provide us with an easy syntax for making **if else** conditional operations in its standard syntax. The way it is done is by using `cond` statement, which allows us to check multiple outcomes of a particular action and do different things depending on its result. The `cond` will execute where the first condition is met, a default condition `true` must be specified in order to handle all of the situations in which we have not matched any of the upper conditions.  

Cond statements are used where we want to execute a code on the basis of several
conditions. It works like an if....else construct in several other programming
languages.

The syntax of a `cond` statement is as follows
```
cond do
  boolean_expression_1 -> #Execute if this condition is true
  boolean_expression_2 -> #Execute if this condition is true
  ...
  true -> #Execute if none of the above conditions are true
end
```

If any of the boolean_expression Boolean expressions evaluates to true, then the
block of code inside the statement will be executed.
The way cond statement works is - it will start from the first condition and check if it
is true. If true, it will execute the code corresponding to that condition, otherwise, it
will move on to the next condition. It will repeat this till a condition matches. If no
condition matches, it raises a CondClauseError, i.e., the condition clause was not
satisfied. To prevent this, a true statement should always be used at the end of a
cond statement.

Example:
```
guess = 46
cond do
guess == 10 -> IO.puts "You guessed 10!"
guess == 46 -> IO.puts "You guessed 46!"
guess == 42 -> IO.puts "You guessed 42!"
true
 ->
 IO.puts "I give up."
end
The above program generates the following result −
You guessed 46!
```


```
iex> cond do
...>   2 + 2 == 5 ->
...>     "This will not be true"
...>   2 * 2 == 3 ->
...>     "Nor this"
...>   1 + 1 == 2 ->
...>     "But this will"
...> end
"But this will"
```
If all of the conditions, are evaluated as false. the cond operator returns an error. To prevent this from happening a true clause must be specified.

```
iex> cond do
...>   7 + 1 == 0 -> "Incorrect"
...>   true -> "Catch all"
...> end
"Catch all"
```
```
iex> cond do
...>   hd([3, 2, 8]) ->
...>     "ok"
...> end
"ok"
```

### Case


`Case` statement can be considered as a replacement for the **switch** statement in
imperative languages. `Case` takes a variable/literal and applies pattern matching to
it with different cases. If any case matches, Elixir executes the code associated with
that case and exits the case statement. If no match is found, it exits the statement
with an CaseClauseError that displays no matching clauses were found. You
should always have a case with **`_`** which matches all values. This helps in prevention
of the above mentioned error. Also this is comparable to the default case in switch-
case statements.


The syntax of an if statement is as follows 
```
case value do
matcher_1 -> #code to execute if value matches matcher_1
matcher_1 -> #code to execute if value matches matcher_2
matcher_1 -> #code to execute if value matches matcher_3
...
_ -> #code to execute if value does not match any of the above
end
```
Example:
```
case 3 do
1 -> IO.puts("Hi, I'm one")
2 -> IO.puts("Hi, I'm two")
3 -> IO.puts("Hi, I'm three")
_ -> IO.puts("Oops, you dont match!")
end
```
The above program generates the following result:
```
Hi, I'm three
```


Case allows us to compare a value against many patterns until we find a matching one:
```
iex> case {1, 2, 3} do
...>   {4, 5, 6} ->
...>     "This clause won't match"
...>   {1, x, 3} ->
...>     "This clause will match and bind x to 2 in this clause"
...>   _ ->
...>     "This clause would match any value"
...> end
"This clause will match and bind x to 2 in this clause"
```
If you want to pattern match against an existing variable, you need to use the `^` operator:
```
iex> x = 1
1
iex> case 10 do
...>   ^x -> "Won't match"
...>   _ -> "Will match"
...> end
"Will match"
```
Clauses also allow extra conditions to be specified via guards:
```
iex> case {1, 2, 3} do
...>   {1, x, 3} when x > 0 ->
...>     "Will match"
...>   _ ->
...>     "Would match, if guard condition were not satisfied"
...> end
"Will match"
```
The first clause above will only match when x is positive.

Keep in mind errors in guards do not leak but simply make the guard fail:
```
iex> hd(1)
** (ArgumentError) argument error
iex> case 1 do
...>   x when hd(x) -> "Won't match"
...>   x -> "Got #{x}"
...> end
"Got 1"
```
If none of the clauses match, an error is raised:
```
iex> case :ok do
...>   :error -> "Won't match"
...> end
** (CaseClauseError) no case clause matching: :ok
Consult the full documentation for guards for more information about guards, how they are used, and what expressions are allowed in them.
```

Example: 
```
iex> pie = 3.14
 3.14
iex> case "cherry pie" do
...>   ^pie -> "Not so tasty"
...>   pie -> "I bet #{pie} is tasty"
...> end
"I bet cherry pie is tasty"
```

### With

`With` is used to combine matching clauses. By default, the comprehension handles functions which return results in the following tuples:
```
{:ok, result} - for success
{:error, result} -> for unsuccess
```

The syntax of the with comprehensions is:

```
with result1 <- func1,
 result2 <- func2 do
 result_of_with
else
 error ->
 handle_error
end
```
If any of the fun1...funN fails, the with statement goes into the error clause.

Example:

```
opts = %{width: 10, height: 15}
with {:ok, width} <- Map.fetch(opts, :width),
     {:ok, height} <- Map.fetch(opts, :height) do
  {:ok, width * height}
end
{:ok, 150}
If all clauses match, the do block is executed, returning its result. Otherwise the chain is aborted and the non-matched value is returned:

opts = %{width: 10}
with {:ok, width} <- Map.fetch(opts, :width),
     {:ok, height} <- Map.fetch(opts, :height) do
  {:ok, width * height}
end
:error
Guards can be used in patterns as well:

users = %{"melany" => "guest", "bob" => :admin}
with {:ok, role} when not is_binary(role) <- Map.fetch(users, "bob") do
  {:ok, to_string(role)}
end
{:ok, "admin"}
```

#### Comprehension

One of the ways to implement a **foreach** loop in Elixir is by using comprehensions. They iterate through an enumerable, and retrun a list containg the results of the operation.

The syntax of a comprehension is:

```
for element <- enumerable do
  #actions
end
```
Where 
```
element <- enumerable
```
is called a **generator**.

Similarly to the conditional operators the comprehensions relies heavily on pattern matching for operationg with values of an enumerable.

```
iex> for {:ok, val} <- [ok: "Hello", error: "Unknown", ok: "World"], do: val
["Hello", "World"]
```
```
iex> values = [good: 1, good: 2, bad: 3, good: 4]
iex> for {:good, n} <- values, do: n * n
[1, 4, 16]
```

It is possible to use multiple generators.

```
iex> list = [1, 2, 3, 4]
iex> for n <- list, times <- 1..n do
...>   String.duplicate("*", times)
...> end
["*", "*", "**", "*", "**", "***", "*", "**", "***", "****"]
```

```
iex> for n <- list, times <- 1..n, do: IO.puts "#{n} - #{times}"
1 - 1
2 - 1
2 - 2
3 - 1
3 - 2
3 - 3
4 - 1
4 - 2
4 - 3
4 - 4
```


##### Filters

Filters are the way to filter out values in the enumerable which is provided in the comprehension. If the condition returns flase or nil for a particular element, that element is beign excluded from the list of results and from the block of code for working with the elemens itself.

Examples:
```
IO.puts(for x <- 1..10, is_even(x), do: x)

[2, 4, 6, 8, 10]
```

```
iex> for i <- 1..5, i < 4, do: i
[1, 2, 3]
```


Multiple filters can be specified in a single comprehension:

```
import Integer
iex> for x <- 1..100,
...>   is_even(x),
...>   rem(x, 3) == 0, do: x
[6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 96]
```



If a map is passed to a comprehension, the result is a list of the structure results in the comprehension's body:

```
iex(23)>  for {key, val} <- %{"a" => 1, "b" => 3, "c" => 4}, do: {key, val*val}
[{"a", 1}, {"b", 9}, {"c", 16}]
iex(24)>  for {key, val} <- %{"a" => 1, "b" => 3, "c" => 4}, do: %{key => val*val}
[%{"a" => 1}, %{"b" => 9}, %{"c" => 16}]
```

However, we can specify that we want the result to be different form a lsit, if we use the keyword `:into`.

###### Using :into

If we want the result of the example above to be a map.

```
iex(37)> for {key, val} <- %{"a" => 1, "b" => 3, "c" => 4}, into: %{}, do: {key, val}  
%{"a" => 1, "b" => 3, "c" => 4}
```

Using :into, also let’s us create a map from a keyword list:

```
iex> for {k, v} <- [one: 1, two: 2, three: 3], into: %{}, do: {k, v}
%{one: 1, three: 3, two: 2}
```



##### Immutable variables

As being said variables in Elixir are imutable, comprehensions do not make any difference.

```
iex> i = 503
503

iex> for i <- 1..3, do: i*i
[1, 4, 9]

iex> i
503
```


#### Guards


Guards are an unique feature in elixir the provide conditional checks in control structures and functions. They can set a condition in the execution of a condition or a function.
There is a limitation in the allowed expressions in a guard. Some of the allowed expressions are:

```
- comparison operators (==, !=, ===, !==, >, >=, <, <=)
- strictly boolean operators (and, or, not)
- arithmetic unary and binary operators (+, -, +, -, *, /)
- `in` and `not in` operators (as long as the right-hand side is a list or a range)
- "type-check" functions (is_list/1, is_number/1, etc.)
- functions that work on built-in datatypes (abs/1, map_size/1, etc.)
```

In Elixir, one can create multiple implementations of a function with the same name, and specify rules which will be applied to the parameters of the function **before calling the function** in order to
determine which implementation to run.

Example:

```
def empty_map?(map) when map_size(map) == 0, do: true
def empty_map?(map) when is_map(map), do: false
```

It is possible to write multiple guard clauses for a singe function or a condition.

Example:

```
defmodule MyInteger do
  defguard is_even(value) when is_integer(value) and rem(value, 2) == 0
end
```


Guards can be implemented in several constructs, for example:

- function clauses:
```
def foo(term) when is_integer(term), do: term
def foo(term) when is_float(term), do: round(term)
```

- case expressions:
```
case x do
  1 -> :one
  2 -> :two
  n when is_integer(n) and n > 2 -> :larger_than_two
end
```

```
iex> case {1, 2, 3} do
...>   {1, x, 3} when x > 0 ->
...>     "Will match"
...>   _ ->
...>     "Won't match"
...> end
"Will match"
Check the official docs for Expressions allowed in guard clauses.
```



- anonymous functions:

```
iex> f = fn
...>   x, y when x > 0 -> x + y
...>   x, y -> x * y
...> end
#Function<12.71889879/2 in :erl_eval.expr/5>
iex> f.(1, 3)
4
iex> f.(-1, 3)
-3
```

- for

It is done with filters.

```
IO.puts(for x <- 1..10, is_odd(x), do: x)

[2, 4, 6, 8, 10]
```



- with

```
defmodule Test do
  def test(res) do
    with {:ok, decode_res} when is_map(decode_res) <- res
    do
      IO.inspect "ok"
    else
      decode_res when is_map(decode_res) -> IO.inspect decode_res
      _ ->
        IO.inspect "error"
    end
  end
end
Test.test({:ok , nil})
Test.test({:ok , 12})
Test.test({:ok , %{}})
```


Example:

```
defmodule Greet do
  def hey(name) when is_atom(name) do
    name |> to_string |> hey
  end
  
  def hey(name) when is_binary(name) do
    IO.puts "Hello, " <> name
  end
end
```

Example: 


```
defmodule Greeter do
  def hello(names, language_code \\ "en")

  def hello(names, language_code) when is_list(names) do
    names
    |> Enum.join(", ")
    |> hello(language_code)
  end

  def hello(name, language_code) when is_binary(name) do
    phrase(language_code) <> name
  end

  defp phrase("en"), do: "Hello, "
  defp phrase("es"), do: "Hola, "
end

iex> Greeter.hello ["Sean", "Steve"]
"Hello, Sean, Steve"

iex> Greeter.hello ["Sean", "Steve"], "es"
"Hola, Sean, Steve"
```


# Exercises

1. Implement functions, that solve a quadratic equation using the conditional operators and with. The coeficients are passed as a tuple, and each conditional operator should be implemented in a seperate function.


2. Implement a function, that when given a list and a symbol, creates a string, that contains all the elements in the list, joined by the symbol you provided
```
ex2([1,2,3,4], ",")
["1,", "2,", "3,", "4,"]
```
    
3. Implement a function, that given a list, an integer, and a value, returns the item, that is at the integer’s position in the list, and if the list has less elements than the list, return the value
```
ex3([1,2,3], 2, 100)
 3

ex3([1,2,3], 4, 100)
 100
```

4. Implement a function, that given a list and an integer (n), returns the first n elements from the list. If the length of the list is less than n, return the whole list
```
ex4([1,2,3], 2)
 [1,2]
ex4([1,2,3], 540)
 [1,2,3]
```

5. Write a comprehension, that given a list of strings, uppercases all of them
Write a comprehension, that given a list of strings, returns a list of the uppercased version of the ones that are under 5 characters
You have a list of titles, and list of names
titles = ["Mr. ", "Mrs. "]
names = ["Ivan Georgiev", "Nikola Nikolov", "Antoaneta Velieva"]
    
Write a comprehension that combines each title with each name

Build upon the previous comprehension, giving the “Mrs ” title if the last name ends on “a”, otherwise use the other one

6. Write a function which checks the number of elements in a tuple, if ther are more than 4 it should return "Shouldn't you use a list."

7. Write a function that takes a list of numbers and calculates the product of all of them.

8. Write a function takes a lsit of numbers and returns a new list containing only the even numbers.

9. Write a function that takes a list of strings and concatenates all of them.

# Homework

1. Write a function which solves the following equations, using a condtional operator of your choice. The function must check wheater the problem(a^3..b^3) is with + or -, transform it into the bottom equation and calculate the value of a and b.
```
a^3−b^3=(a−b)*(a^2+a*b+b^2) 

a^3+b^3=(a+b)*(a^2−a*b+b^2)
```

2. John is a regular bulgarian, whose responses are quite limited. 
If you ask him a question he says "Eurofootball matches haven't gone out.".
If you yell(caps lock) at him, he tells you to "Shut up.".
If you yell a question he says "Only the weak shout.".
If you dont tell him anything he says "Yo.".
If you tell him anything different he says "K".

Write a function/functions which implement his behavior. 
Bonus: Use conditional operators.

3. Write a function which takes a string as an argument, checks it's length and if it is grater than 9, returns "long string", in other case "short string".

4. Write a function that compares two strings and returns message about which string is longer or if they are equal.

5. Write a function which takes a list, transforms the first into a string and returns it as a result. In any other cases it should return an empty string.


6. Write a function that, receive two parameters
- if the second parameter is greater than 1, the returned value is the second parameter
- if the first argument is equal to three, the returned value is the second parameter
- if the first argument is greater than 4, the returned values is "ok"

7. Write a function, that:
- If it receives a tuple with three elements and the second is greater than 1, it should return the second element.
- If it receives a tuple with two elements and the first equals 3, it should return the second element.
- If it receives a tuple with one elemnt and it is greater than 4, it should the return the element.

8. Write a function that takes a tuple as an argument, and using a conditional operator by your choice, it should return the first element if it is greater than the second. In other case, the sum of the second and third.

9. You have a structure containing a few football teams, write a function that takes the team names and result and updates the player's stats. 
Make the code to work even if the names of teams are changed or if there are more than two teams in the database. If the names of the teams are present in the struct, the match can be made.
You are free to structure the code the way you want.

Rules:
  - if team scored 1 - goals is for atk
  - if team scored 2 - 2 goals are for atk
  - if a team scored 3 - 2 goals are for atk one for mid,
  - if team scored 4 - 2 goals are for atk one for mid, one for def
  - if team conceed a goal - gk is -1

  ```
  %{
    "Red" => %{
      "gk" => {"Ali Baba", 28, "right", 0},
      "def" => {"Ivan Ivanov", 34, "right", 0},
      "mid" => {"Eli Marques", 22, "left", 0},
      "atk" => {"Valeri Bozhinov", 35, "right", 0}
    },
    "Blue" => %{
      "gk" => {"Zdravko Zdravkov", 48, "left", 0},
      "def" => {"Elin Topuzakov", 42, "left", 0},
      "mid" => {"Obi-Wan Kenobi", 18, "right", 0},
      "atk" => {"Cherno Samba", 32, "left", 0}
    },
    "Green" => %{
      "gk" => {"Ilko Pirgov", 22, "left", 0},
      "def" => {"Jackie Chan", 25, "left", 0},
      "mid" => {"Hali Thiam", 33, "right", 0},
      "atk" => {"Big Shaq", 20, "left", 0}
    }
  }
  ```


  ```
  "Red" beats "blue" 2-1 !
  %{
    "Red" => %{
      "gk" => {"Ali Baba", 28, "right", -1},
      "def" => {"Ivan Ivanov", 34, "right", 0},
      "mid" => {"Eli Marques", 22, "left", 0},
      "atk" => {"Valeri Bozhinov", 35, "right", 2}
    },
    "Blue" => %{
      "gk" => {"Zdravko Zdravkov", 48, "left", -2},
      "def" => {"Elin Topuzakov", 42, "left", 0},
      "mid" => {"Obi-Wan Kenobi", 18, "right", 0},
      "atk" => {"Cherno Samba", 32, "left", 1}
    },
    "Green" => %{
      "gk" => {"Ilko Pirgov", 22, "left", 0},
      "def" => {"Jackie Chan", 25, "left", 0},
      "mid" => {"Hali Thiam", 33, "right", 0},
      "atk" => {"Big Shaq", 20, "left", 0}
    }
  }
  ```