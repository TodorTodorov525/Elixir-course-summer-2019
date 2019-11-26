1.
  maybe_pluralize = fn
    1 -> "person"
    _ -> "people"
  end
  maybe_pluralize.(1)
  maybe_pluralize.(5)


2.
fizz_func = fn
  0,0,_ -> "FizzBuzz"
  0,_,_ -> "Fizz"
  _,0,_ -> "Buzz"
  _,_,c -> c
end

2.
  fizz_func = fn
    0,0,_ -> "FizzBuzz"
    0,_,_ -> "Fizz"
    _,0,_ -> "Buzz"
    _,_,c -> c
  end

3.
  fun = fn(a,b) -> a <> b end


4.
  fun = fn
  (a,b) -> String.length(a) > String.length(b)
  end


5.
  exercise5 = fn ->
    text = "wonderful"
    "String size: #{String.length(text)}
    Its third letter: #{String.at(text,2)}
    Transormed: #{String.capitalize(text)}"
  end


6.
  String.replace("I hate homework", " ", ".")
  String.reverse("I hate homework")
