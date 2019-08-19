# Elixir course lesson №7

## Recursion

Due to the language's immutability, Elixir doesn't provide us with the standard common implementation of a for loop. As a result one of the ways to implement a for loop is by using recursion.

```
defmodule Loop do
  def puts_times(0, _message) do
    # Recursion terminator
  end

  def puts_times(n, message) do
    IO.puts message
    puts_times(n - 1, message)
  end
end

iex> Loop.puts_times(5, "Hello Loop!")
Hello Loop!
Hello Loop!
Hello Loop!
Hello Loop!
Hello Loop!
nil
```

There are a few approaches in the implementation of recursion.

#### Counting Down

The simplest model of recursion with a natural limit is a countdown, like the one used for rocket launching. You start with a large number and count down to zero. When you reach zero, you’re done (and the rocket takes off, if there is one).

To implement this in Elixir, you’ll pass a starting number to an Elixir function. If the number is greater than zero, it will then announce the number and call itself with the number minus one as the argument. If the number is zero (or less), it will announce blastoff! and end.

Example:
```
defmodule Count do
  def countdown(from) when from > 0 do
    IO.inspect(from)
    countdown(from-1)
  end
  def countdown(from) do
    IO.puts("blastoff!")
  end
end
```

Example of a recursion using only one function:
```
def hello_world(count \\ 0) do
  IO.puts("Hello, World!")
  if count < 10 do
    new_count = count + 1
    hello_world(new_count)
  end
end
```

The same functionality but using a few functions instead of an `if` conditional operator:

```
def hello_world(count \\ 0)
def hello_world(count) when count >= 10, do: nil

def hello_world(count) do
  IO.puts("Hello, World!")
  new_count = count + 1
  hello_world(new_count)
end
```

Example: This is how a summing function can be implemented recursively. The numbers are passed as a list.
```
def sum_numbers2([head | tail]) do
  ## the function is called again, but this time the tail is passed as an argument, ## on the right side of the plus sign is the old value on the left is the new one 
  val = sum_numbers2(tail) + head
  IO.inspect(sum_numbers2(tail), label: "left side")
  IO.inspect(head, label: "right side")
  val
end

def sum_numbers2([]) do
  0
end
```

Instead of using the functions provided by the Enum module, this solution calls itself until the list is empty. It does so using two function heads.

When the first item in the list (the head) is a number, we’ll call sum_numbers2/1 with the rest of list (anything but the head, called the tail). This call returns a number we’ll add our current head to. When the list is empty, we’ll return 0.






#### Counting up

Counting up is trickier because there’s no natural endpoint, so you can’t model your
code. Instead, you can use an accumulator. An accumulator is an extra
argument that keeps track of the current result of past work, passing it back into a
recursive function. (You can have more than one accumulator argument if you need,
though one is often sufficient.)

```
defmodule Count do
  def countup(limit) do
    countup(1,limit)
  end
  defp countup(count, limit) when count <= limit do
    IO.inspect(count)
    countup(count+1, limit)
  end
  defp countup(count, limit) do
    IO.puts("finished!")
  end
end
```

This is how factoriel is calculated recursively:
Example:
```
def factorial(n) do
  factorial(1,n,1)
end
defp factorial(current, n, result) when current <= n do
  new_result = result * current
  IO.puts("#{current} -> #{new_result}.")
  factorial(current+1, n, new_result)
end
defp factorial(_current, _n, result) do
  IO.puts("finished!")
  result
end
```


### Tail call optimization

Tail call optimization is a technique that allows the compiler to call a function without using any additional stack space. This is achieved by making the function end (or return) with a call to another function...in this case itself because we are focusing on recursion.

Sum of numbers in a list using tail call optimization.
```
def sum_numbers3(list) do
  do_sum_numbers3(list, 0)
end

defp do_sum_numbers3([head | tail], sum) when is_number(head) do
  do_sum_numbers3(tail, sum + head)
end

defp do_sum_numbers3([], sum) do
  sum
end
```

This example is yet another implementation of the function from before. However, this example is tail-recursive, meaning it doesn’t need to await a call to itself before continuing. It does so by keeping an accumulator (sum) that keeps the current value instead of stacking function calls.


The sum_numbers3/1 function is the public function, which calls the private do_sum_numbers3/2 function with the passed list and an accumulator of 0 to start with.
Much like the previous example, do_sum_numbers3/2’s first function head matches lists with a numeric head. It calls itself with the list’s tail, and the head added to the accumulator.
Finally, the exit clause returns the accumulator.
By calling itself at the end of the function and passing the accumulator with all calculated values, the Erlang VM can execute a trick called tail-call optimization, which allows it to circumvent adding new stack frames. Instead, it uses the current frame by jumping back up to the beginning of the function.

Tail call optimization allows functions calling themselves without running into stack problems.


# Exercises

1. Write a recursive function which concatenates all of the elements of a list.

2. Write a recursive function which calculates the sum of the elements in a list.

3. Write a recursive function which calculates the factioriel of a number.
