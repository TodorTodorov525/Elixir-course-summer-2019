1.
  def ex1(%{first_name: fname, second_name: sname, age: age}) do
    "Hello, #{fname} #{sname}"
  end


2.
  def ex2(param) do
    param |> tuple_size() |> print_message()
  end

  def print_message(num) do
    print = fn
      0 -> IO.puts("OK")
      1 -> IO.puts("OK")
      2 -> IO.puts("OK")
      3 -> IO.puts("OK")
      _ -> IO.puts("Shouldn’t you use list?")
    end

    print.(num)
  end

2. Solution using anonymous function
  length_of_tuple = fn
    {a} -> 1
    {a,b} -> 2
    {a,b,c} -> 3
    {a,b,c,d} -> 4
    _ -> "Shouldn't you use a list"
  end


3.
  def ex4 do
    [1994, 600, 1965, 0, 1, 2019, 2008, 1921, 1936, 1414, 2000, 1992, 2004]
    |> Enum.filter( fn year -> year >= 2000 end)
  end


4.
  def ex3 do
    1..100
    |> Enum.filter( fn num -> rem(num, 2) == 0 && num != 100 end)
    |> Enum.filter(fn num -> rem(num, 3) != 0 end)
    |> Enum.map_every(2, fn num -> num * 100 end)
  end


5.
  def ex5 do
    [%{name: "Donald", age: 10}, %{name: "Jerry", age: 21}, %{name: "Tom", age: 24}]
    |> Enum.filter(fn person -> person.age > 18 end)
  end

  
  homework recursion!!!
  
      def hw5(list) do
        itemToString = fn(person) ->
            %{name: name, age: age} = person
            "#{name}: #{age} years old"
        end

        Enum.map_every(list, 1, fn person -> itemToString.(person) end)
    end
  
  
