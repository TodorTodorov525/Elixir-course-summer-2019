# Elixir course lesson №3

## Collections(list, tuple, map,  keyword list)

### List

The list is a simple collection of values. It can consist repeating values. They are represented internaly as linked lists and they have the following characteristics:

- They support adding/removing elements (adding from the front is faster than from the back)
- Memory usage scales with the list size. The more elements the list has, the more memory it requires
- Fetching elements may sometimes be slow (because the lists are distributed arbitrarily in no particular order, with each element holding a reference to the next one)

Linked list characteristics: https://cdn1.imggmi.com/uploads/2019/7/15/c505f22f0abac0ef89e3babe5ddbd6cd-full.png

In elixir retrieving the last element is O(n). Because the interpretaor doesn't know the reference to the last element.

Visual expression of a linked list: https://cdn1.imggmi.com/uploads/2019/7/15/f904749140b963123f2e061871bebedb-full.png

In order to reach the 3rd element, the system needs to know where the list begins (which is pretty much all it knows), and then traverse from there. This means that to get to the 100th element, all 99 elements before it have to be traversed.

To add a new element, a new memory slot is reserved anywhere where free memory is available, and then a reference to it is added to the previous last element.

With a list, adding/removing elements is a relatively cheap operation that doesn’t need to mess with existing memory, which is why they’re more suited for dynamic collections.
Each term Term in the list is called an element. The number of elements is said to be the length of the list.

Formally, a list is either the empty list `[]` or consists of a head (first element) and a tail (remainder of the list). The tail is also a list. The latter can be expressed as `[H|T]`.

```
iex(25)> [h|t] = [1,2,3]
[1, 2, 3]
iex(26)> h #head
1
iex(27)> t #tail
[2, 3]
```

 =The symbol `|` is used for embedding a list's values into another list. This lieads to the notation `[Term1,...,TermN]` being equivalent to `[Term1|[...|[TermN|[]]]]`.

Example:

```
iex(23)> [1|[]]
[1]
iex(24)> [1|[2|[]]]
[1, 2]
iex(20)> [1,2,3] === [1|[2|[3|[]]]]
true
```

List are linked list, and optimized for TCO(tail call optimisation). That is why you will often see the [head | tail] representation. They are not so good for asking the 5th element for example.

List concatenation is done by the `++` operator and it is a operation done between lists. It can be done from the front or form the back of the list. Trying to concatenate a varioable with a list, will lead to breaking the list's structure and the need to make further informations to fix the list's structure so that it can be usable with all of the integrated functions and most common operations.

Example:

```
iex(28)> list =[3.14, :pie, "Apple"] #list definitoion
[3.14, :pie, "Apple"]
iex(29)> "new first" ++ list ++ "new last"
** (ArgumentError) argument error
    :erlang.++("new first", [3.14, :pie, "Apple" | "new last"])
iex(29)>  list ++ "new last"
[3.14, :pie, "Apple" | "new last"]
iex(30)> "new first" ++ list              
** (ArgumentError) argument error
    :erlang.++("new first", [3.14, :pie, "Apple"])
iex(30)> "new first" ++ list
** (ArgumentError) argument error
    :erlang.++("new first", [3.14, :pie, "Apple"])
iex(30)> ["new first"] ++ list ++ ["new last"]
["new first", 3.14, :pie, "Apple", "new last"]
```

List substraction is done by `--` operator, and analogically to concatenation, requires lists as operands. The values from the right list are searched through  the list on the left and the first match of a particular value is removed. 

Example:

```
iex(36)> list
[3.14, :pie, "Apple"]
iex(37)> 3.14 -- list
** (ArgumentError) argument error
    :erlang.--(3.14, [3.14, :pie, "Apple"])
iex(37)> [3.14] -- list
[]
iex(38)> list -- [3.14]
[:pie, "Apple"]
iex(39)> ["X", "X", "Y"] -- ["X"]    
["X", "Y"]
iex(40)> ["X", "X", "Y"] -- ["X", "Y"]
["X"]
```

###### List pattern matching.

Example:

```
iex> list = [1, 2, 3]
[1, 2, 3]
iex> [a, b, c] = list
iex> a
1
iex> b
2
iex> c
3

iex> list = [1, 2, [3, 4, 5]]
[1, 2, [3, 4, 5]]
iex> [a, b, c] = list
iex> a
1
iex> b
2
iex> c
[3, 4, 5]


iex> list = [1, 2, 3]
[1, 2, 3]
iex> [a, 1, b] = list
** (MatchError) no match of right hand side value: [1, 2, 3]


iex> [1, _, _] = [1, 2, 3]
iex> [1, _, _] = [1, "cat", "dog"]
iex> [a, _, b, _] = [3, "Tomy", :ani, 7]
[a, _, b, _] = [3, "Tomy", :ani, 7]
iex> a
3
iex> b
:ani
```

A variable can only have one value.

Example:

```
iex(25)> b = 1
1
iex(26)> [b, b]
[1, 1]
iex(27)> [b, b, b, b, b, b, b, b]
[1, 1, 1, 1, 1, 1, 1, 1]
iex(25)> [b, b] = [1, 2]
** (MatchError) no match of right hand side value: [1, 2]
```

A list's length is considered the number of it's elements. The count starts from one.

```
iex(43)> list
[3.14, :pie, "Apple"]
iex(44)> length(list)
3
```

### Tuple

Tuples are a collection in which the values are store successively in the memory. Retrieving data and about the values or the tuple itself is rather cheap, but modifications are expensive, because when an element is added or removed or a value modified, Elixir creates a copy of the whole tuple with values updated after the modification. Tuples are defined with curly brackets. Often tuples are used as a mechanism for returning information about the succes of a function.

Example:

```
iex> {1, :two, "three"} 
{1, :two, "three"}
A tuple element can be accessed by index with the elem() function:
iex> tuple = {1, :two, "three"} 
iex> elem(tuple, 0)
1
iex> elem(tuple, 2) 
"three"
iex> File.read("path/to/existing/file")
{:ok, "... contents ..."}
iex> File.read("path/to/unknown/file")
{:error, :enoent}
iex> tuple = {:ok, :example}
iex> {:ok, atom} = tuple  # creates new tuple with pattern matching
iex> {:ok, atom, %{}}     # adds new element to new tuple
{:ok, :example, %{}}
```
This leads to the following conclusions:

- They are meant to hold a fixed number of elements
- As a result of the previous point, memory usage is also static, and allocated upfront.
- The data structure does not support addition/removal of elements. Any change requires recreating an entirely new version of the structure.
- In memory, this looks a lot different from lists -  https://cdn1.imggmi.com/uploads/2019/7/15/ed8d8681fd525a11bdae1878c566582b-full.png
- A reference to where the tuple’s memory begins
- The index of the element you’re accessing
- Coming from other programming languages, you might recognize this as being very similar to accessing a static array. And you’d be right. Tuples are not much more than abstractions to statically-sized arrays. The difference comes in the semantic meaning given to both.
- The memory usage is 100% predictable.



###### Tuple pattern matching.

```
iex(55)> {a,b,c} = {1,2,{3}} 
{1, 2, {3}}
iex(56)> a
1
iex(57)> b
2
iex(58)> c
{3}
```



### Map

The map in Elixir is a collection storing key-value pairs. The keys can be of any type, but the Elixir's coding standart caontaing the language's best practisises requires them to be atoms or strings. Although this is a full valid map. 

``` 
iex(60)> %{%{<<1>> => 1} => "a"} # the inner key is a binary, the outer is a map
%{%{<<1>> => 1} => "a"}
```

The syntax varies depending on the key's data type. The values can also be of any type.

Example:

```
iex(1)> %{} #empty map
%{}
iex(2)> %{"key" => "value"} # when the key is a string, `=>` is the way to pair it with a value
%{"key" => "value"}
iex(3)> %{key: "value"} # to define the key is an atom, it must end with an ':'
%{key: "value"}
iex(4)> %{"key" => 4}      
%{"key" => 4}
iex(5)> %{key: 4}      
%{key: 4}
```

Keys are unique, and can only point to a single value. 

Example:

```
iex> %{foo: "bar", foo: "hello world"}
%{foo: "hello world"}
```

There is a an easy way to update a map.

Example:

```
iex(7)> map = %{foo: "bar", hello: "world"}
%{foo: "bar", hello: "world"}
iex(8)> %{map | foo: "baz"}
%{foo: "baz", hello: "world"}
```

Retrieving a key is also easy, the syntax varies because of the key type.

```
iex(2)> map = %{:atom => "value2", "string" => "value1"}
%{:atom => "value2", "string" => "value1"}
iex(3)> map.atom
"value2"
iex(4)> map["string"]
"value1"
iex(5)> map2 = %{%{<<1>> => 1} => "a"}
%{%{<<1>> => 1} => "a"}
iex(7)> map2[%{<<1>> => 1}]           
"a"

#Bonus
iex(8)> Map.keys(map2)                                                              
[%{<<1>> => 1}]                                                                     
iex(9)> [m]=Map.keys(map2)                                                          
[%{<<1>> => 1}]                                                                     
iex(10)> m[<<1>>]                                                                   
1                        
```

Maps are not ordered.



### Keyword list 

Keyword lists in Elixir are actually list of tuples. Which first element is an atom. 

Example:

```
iex> [foo: "bar", hello: "world"]
[foo: "bar", hello: "world"]
iex> [{:foo, "bar"}, {:hello, "world"}]
[foo: "bar", hello: "world"]
```

They keyword has the characteristics of a list. And more:

- The keys are atoms.
- The keys are ordered.
- The keys are not unique.
Keywords are often used in passing optional arguments in functions.

Keywords can be defined by two different ways. As a list of tuples, or `atom: value` pair.

Example:

```
iex(15)> list1 = [ key1: "value1", key2: "value2" ]                    
[key1: "value1", key2: "value2"]
iex(16)> list2 = [{:key1, "value1"},{:key2, "value2"}]
[key1: "value1", key2: "value2"]
iex(17)> list1 === list2
true
iex(19)> Enum.at(list1, 0)
{:key1, "value1"}
```

This is how the keyword is represented, the first value points to the second key and so on.
https://cdn1.imggmi.com/uploads/2019/7/15/50ce00f4371e2b133d895f6ac5e8a12d-full.png

Keyword appending is analogical to list appending.

Example:

```
iex> list = [{:a, 1}, {:b, 2}]
[a: 1, b: 2]
iex> list == [a: 1, b: 2]
true
As you can see above, Elixir supports a special syntax for defining such lists: [key: value]. Underneath it maps to the same list of tuples as above. Since keyword lists are lists, we can use all operations available to lists. For example, we can use ++ to add new values to a keyword list:

iex> list ++ [c: 3]
[a: 1, b: 2, c: 3]
iex> [a: 0] ++ list
[a: 0, a: 1, b: 2]
Note that values added to the front are the ones fetched on lookup:

iex> new_list = [a: 0] ++ list
[a: 0, a: 1, b: 2]
iex> new_list[:a]
0
```

Difference between keyword list and map.
```
                   ┌──────────────┬────────────┬
                   │ Keyword List │ Map/Struct │
┌──────────────────┼──────────────┼────────────┼
│ Duplicate keys   │ yes          │ no         │
│ Ordered          │ yes          │ no         │
│ Pattern matching │ yes          │ yes        │
│ Performance¹     │ —            │ —          │
│ ├ Insert         │ very fast²   │ fast³      │
│ └ Access         │ slow⁵        │ fast³      │
└──────────────────┴──────────────┴────────────┴
```

# Exercises 

Those that are undone, are assigned as homework.

1. Which of the following will match:
```
a = [1, 2, 3]
a = 4
4 = a
[a, b] = [ 1, 2, 3 ]
a = [ [ 1, 2, 3 ] ]
[a] = [ [ 1, 2, 3 ] ]
[[a]] = [ [ 1, 2, 3 ] ]
[x, x] = [1, 1]
[x, x] = [2, 3]
[x, _, x] = [2, 3]
[x, z, x] = [2, 3, 2]
[x, 3, x] = [2, 3, 2]

[{key, value}] = [key1: "value"]
is this valid -> `[{key: "pair"}, {fruit: apple}]`

%{person => [home]} = %{%{"user" => ["color", "tuple", "hobby"]} => "address"}
%{team: points} = %{"points" => 4}
%{team: 4} == %{"points" => 4} 
```

2. Write a pattern to get “Alice” in variable named `first_name`, and 18 in variable named `age` from the following structure:
```
[first_name: "Alice", age: 18]
```

3. Write a pattern to get the same things from the following structure:
```
{:ok, [%{first_name: "Alice", age: 18}, %{first_name: "Bob", age: 21}]}
```


4. Create functions that does the following:
```
to_tuple.([2, 3], [4, 5])	[{2, 4}, {3, 5}]
to_keyword_list.({:a, :b, :c}, {1, 2, 3})	[a: 1, b: 2, c: 3]
```

5. Write a function that checks if list is empty. It should return “true” if it is, and “false” otherwise.

6. Create a tuple consisting of an atom “:ok” and string “Alice”. Pattern match the string in a variable “first_name”

7. Create a function which receives a tuple consisting of three elements, an atom, an integer and a string. Create a pattern to match the integer and the string from tuple argument in variables named “age” and “first_name” Make the pattern match only if the atom has a value “:ok”




