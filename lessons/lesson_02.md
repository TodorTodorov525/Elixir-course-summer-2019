# Elixir course lesson №2

## Basic variable types, basic operations, anonymous functions

### Basic types

The basic types in Elixir are: 
- Integer
- Float
- Boolean
- Atom
- String
- nil

Some of their representations in the language are:
```
iex> 1          # integer
iex> 1.0        # float
iex> true       # boolean
iex> :atom      # atom
iex> "elixir"   # string
iex> nil        # nil
```


#### Integer
Integers can be represented in decimal, binary, octal and hexadecimal numeric systems, as well as with a positive and negative sign. By default, it is assumed that the number is positive.

###### Example:
```
iex(1)> 55
55
iex(2)> 0b110111  #The number in binary numeric system.
55
iex(3)> 0o67 #The number in octal numeric system.
55
iex(4)> 0x37   #The binary in hexadecimal numeric system.
55
iex(5)> +0x77 
119
iex(6)> -0x77 
-119
iex(5)> 0b110111 + 0o67 + 0x37 #Arithmetic operations are feasible between numbers of different numeric systems.
165
```


#### Float
These type of numbers can be represented in two ways. The common way of representing a float, and as an exponent.

###### Example:
 ```
iex(6)> 5.5 #common way of representing float number
5.5
iex(7)> 1.0e-4 #case where the exponent is returned in the common representation
0.0001
iex(8)> 1.0e-5 #exponent
1.0e-5
iex(9)> 0.1e-4 #if the number is less than 1, the power of the exponent is incremented
1.0e-5
iex(10)> 10.0e5 #if the number is greater than 10, the power of the exponent is incremented
1.0e6
iex(11)> 0o67 + 0x37 + 0b110111 + 5.5 + 5.5e1 #sum of values of different numeric types with float numbers 
225.5
```


#### Boolean
The boolean values are `true` and `false`.


#### Atom
Atoms are specific values in Elixir. The value of an atom is its name. Often they are used to expressing the state of an operation, by using values such as :ok and :error.


###### Example:
```
iex(12)> :atom
:atom
iex(13)> :New_atom
:New_atom
```


##### String
A string is a UTF-8 encoded binary. Each character in the string is represented by a number of bytes, depending on their unicode value. This sometimes leads into a case where the string has a greater byte size than it's length in characters. 

###### Example:
```
iex(14)> "foo"   
"foo"
iex(15)> "програмист"
"програмист"
iex(16)> byte_size("програмист")
20
iex(17)> String.length("програмист")
10
iex(18)> is_binary('hello') #charlists are not binaries, they are list of unicodes (code points values)
false
iex(19)> is_binary("hello") #strings are binaries
true
iex(20)> ?"  #the unicode's code point value
34                                                                                  
iex(21)> ?б   #the unicode's code point value
1073                                                                                
iex(22)> ?Б  #the unicode's code point value           
1041   
iex(134)> ?L + 32 #arithmetic operations are possible between unicode and integer
108
iex(137)> ?L + 3.5e1
111.0
iex(138)> ?L + 3.5e5
350076.0
```

Binaries are in are a specific data type in Elixir. And are a part of of its enrichment. Each binary value(that is a part of an Elixir binary) is represented by 8 bits. Each change into the binary's structure will lead to transforming that binary into a bitstring.
https://cdn1.imggmi.com/uploads/2019/7/11/478eadf9b9c1f9e4c4ea9b4cd5e7dc97-full.png
https://cdn1.imggmi.com/uploads/2019/7/11/623399b7775e48cfcc87ce8760bcab1b-full.png


```
iex(23)> <<8::4>>
<<8::size(4)>>
iex(24)> <<8::3>>
<<0::size(3)>>
iex(25)> <<256 :: utf8>> #Binary transformed into string.
"Ā"
iex(26)> <<1073 :: utf8>> #Binary transformed into string.
"б"
```

##### nil
This is the data type equivalent to NULL in other programming languages

```
iex(111)> nil
nil
```

### Basic operations
Elixir supports all common arithmetic operations.

###### Arithmetic operations

###### Example:

```
iex(27)> 2+2  
4
iex(28)> 2-2
0
iex(29)> 2/2
1.0
iex(30)> 2*2
4
iex(31)> 22 / 3
7.333333333333333
```

It is important to say that using the common divide operator, the result will always be a number with a floating point. If the result must be an integer value the prebuilt function `div` is needed. The remainder can be found by using another prebuilt function `rem`.

###### Example:

```
iex(32)> div(10,3)
3
iex(33)> rem(10,3)
1
```


###### Boolean operations

can be used with any data type
```
iex> ||   #or
iex> &&   #and
iex> !    #not
```

these below require boolean value on their left side
```
iex> and   
iex> or   
iex> not    
```


using an additional module `Bitwise` calculations on bits are possible
```
&&& - AND
<<< - left bitshift
>>> - right bitshift
^^^ - XOR
||| - OR
```

###### Example:

```
iex> -20 || true
-20
iex> false || 42
42

iex> 42 && true
true
iex> 42 && nil
nil

iex> !42
false
iex> !false
true
iex> true and 42
42

iex> false or true
true
iex> not false
true
iex> 42 and true
** (ArgumentError) argument error: 42
iex> not 42
** (ArgumentError) argument error
```

###### Comparison operations
All of the Elixir's comparison operators, use left to right associativity. It is possible to compare values of different types.

```
== - equality
=== - strict equality
!= - inequality
!== - strict inequality
< - less than
> - greater than
<= - less than or equal
>= - greater than or equal
```

###### Example:

```
iex(28)> :p > 5
true
iex(29)> :p > "a"
false
iex(30)> :p > 'w'
false
iex(31)> "w" > 'w'
true
iex(32)> "w" > 2.0
true
```

```
iex(7)> 2.0 > 2
false
iex(8)> 2.0 < 2
false
iex(9)> 2.0 == 2
true
iex(10)> 2.0 === 2
false
```

Atoms are equal if their names are equal.

```
iex> :apple == :apple
true
iex> :apple == :orange
false
```

The atoms `:true` and `:false` are boolean and the same as the boolean values `true` and `false`.

```
iex(3)> :true === true
true
iex(4)> :false === false
true
```


###### String concatenation and interpolation
Strings can be stored in variables, which can be integrated directly into another string (without breaking the quotation syntax). That process is called interpolation. 
The process in which a string is joined with another string is called concatenation.
Strings in Elixir can have line breaks.

###### Example:

```
iex(39)> name = "Todor"     
"Todor"
iex(40)> surname = "Todorov"            
"Todorov"
iex(41)> job = "Elixir developer"
"Elixir developer"
iex(42)> "#{name}" <> surname <> "#{job}"
"TodorTodorovElixir developer"
iex(43)> "#{name} " <> surname <> " #{job}"
"Todor Todorov Elixir developer"
iex(46)> IO.puts "#{name}\n" <> surname <> "\n#{job}"  
Todor
Todorov
Elixir developer
:ok
```

`IO.puts` is a function for printing value into the screen, it's equivalents in other languages are cout, console.log, printf, etc.






### Anonymous functions

Structure:
```
fn(parameters) -> body end
```
The can be assigned to a variable, which will then allow access to that anonymous function. 

###### Example:

```
iex(57)> add = fn a, b -> a + b end 
#Function<12.99386804/2 in :erl_eval.expr/5>
iex(58)> add.(8,9)
17
iex(59)> double = fn a -> add.(a,a) end #function in function
-#Function<6.99386804/1 in :erl_eval.expr/5>
iex(60)> double.(4)  #access an anonymous function
8
```

A function can have multiple bodies, which are separated from the others, by the arguments that are passed to the function. The passed arguments must be the same number.

###### Example:

```
iex(1)> fun = fn                                                    
...(1)> (:hi) -> IO.puts "Hi."                                      
...(1)> (:здрасти) -> IO.puts "Здрасти."                            
...(1)> (param) -> IO.puts "I prefer" <> to_string(param)           
...(1)> end
#Function<6.99386804/1 in :erl_eval.expr/5>
iex(2)> fun.(:hi)
Hi.
:ok
iex(3)> fun.(:здрасти)
Здрасти.
:ok
iex(4)> fun.(:Добър_ден)
I preferДобър_ден
:ok
```

There is a shortened way of presenting anonymous functions.

###### Example:

```
iex(2)> sum = &(&1 + &2)
&:erlang.+/2
iex(3)> sum.(2,3)
5
```

A function can return a function

###### Example:

```
iex(4)> fun1 = fn -> fn -> "Hello" end end
#Function<20.99386804/0 in :erl_eval.expr/5>
iex(5)> fun1.()
#Function<20.99386804/0 in :erl_eval.expr/5>
iex(6)> fun1.().()
"Hello"
```



# Immutable data
The data values in Elixir are immutable. In order to store a new value, one must be reassigned to a variable.

###### Example:

```
iex(56)> string = "test"            
"test"
iex(57)> string <> "1"
"test1"
iex(58)> string
"test"
iex(59)> x = 42
42
iex(60)> (fn -> x = 0 end).()
0
iex(61)> x
42
```




# Exercises 
Those that are undone, are assigned as a homework.

1. Create a function that returns the single or the plural word for a 'person' based on the number provided as an argument.

2. Write a function that takes three arguments. If the first two are zero, return “FizzBuzz.” If the first is zero, return “Fizz.” If the second is zero, return “Buzz.” Otherwise return the third argument.
```
Arguments	Result
0, 0, 5	“FizzBuzz”
0, 1, 2	“Fizz”
1, 0, 2	“Buzz”
1, 1, “Test”	“Test”
```

3. Write an anonymous function called concatenate, which take two strings and returns as a result of their concatenation. 


4. Write a function that takes two strings. If the length of the first in greater than the length of the second return `true`. If it is the opposite, return `false`.

Use documentation String - https://hexdocs.pm/elixir/String.html

5. The string "wonderful" is given. That is it's length, which letter is his third one, Transform it into "Wonderful".

6. The string "I hate homework" is given. Replace the space with "." (I.hate.homework) . Write it backwards ("krowemoh evol I").



- Write your solutions in a .txt file
- Create a github repo(preferably a private one), it will be used to store your homeworks.
- Push the txt into the repo.
- Assign me as a collaborator, so that I can see the files.



