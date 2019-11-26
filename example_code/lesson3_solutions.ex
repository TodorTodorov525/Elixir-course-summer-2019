1.
  a = [1, 2, 3] -> true
  a = 4 -> true
  4 = a -> false/true
  [a, b] = [ 1, 2, 3 ] -> false
  a = [ [ 1, 2, 3 ] ] -> true
  [a] = [ [ 1, 2, 3 ] ] -> true
  [[a]] = [ [ 1, 2, 3 ] ] -> false
  [x, x] = [1, 1] -> true
  [x, x] = [2, 3] -> false
  [x, _, x] = [2, 3] -> false
  [x, z, x] = [2, 3, 2] -> true
  [x, 3, x] = [2, 3, 2] -> true

  [{key, value}] = [key1: "value"] -> true
  is this valid -> [{key: "pair"}, {fruit: apple}] -> false

  %{person => [home]} = %{%{"user" => ["color", "tuple", "hobby"]} => "address"} -> false
  %{team: points} = %{"points" => 4} -> false
  %{team: 4} == %{"points" => 4} -> false


2.  
  [{_, first_name}, {_, age}] = [first_name: "Alice", age: 18]


3. 
  {_, [%{age: age1, first_name: first_name1}, %{age: age2, first_name: first_name2}]} = {:ok, [%{first_name: "Alice", age: 18}, %{first_name: "Bob", age: 21}]}
  {:ok, [%{age: 18, first_name: "Alice"}, %{age: 21, first_name: "Bob"}]}


4.
   to_tuple = fn    
    (a,b) -> [List.to_tuple(a), List.to_tuple(b)]
   end

  to_tuple2 = fn                               
    ([a1,a2], [b1,b2]) -> [{a1, b1}, {a2, b2}]
  end

  to_keyword_list = fn
    ({a,b,c}, {num1, num2, num3}) -> [{a, num1}, {b, num2}, {c, num3}]
  end


5.
  is_empty = fn                            
    [] -> true
    _ -> false
  end


6. 
  {_, first_name} = {:ok, "Alice"}


7. 
  is_ok = fn     
    {:ok, age, first_name} -> [age, first_name]
    _ -> []      
  end

