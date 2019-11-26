defmodule Quadratic do
  def calc({a, b, c}) do
    des = b * b - 4 * a * c
    x1 = (-b + :math.sqrt(des)) / 2 * a
    x2 = (-b - :math.sqrt(des)) / 2 * a
    {x1, x2}
  end

  def calc({b, c}) do
    x1 = c / b
    {x1, x1}
  end

  def quadratic_if({a, b, c}) do
    if b * b >= 4 * a * c and a != 0 do
      calc({a, b, c})
    else
      if a == 0 do
        calc({b, c})
      else
        {:error, "nyama realni koreni"}
      end
    end
  end

  def quadratic_cond({a, b, c}) do
    cond do
      b * b >= 4 * a * c and a != 0 ->
        calc({a, b, c})

      a == 0 ->
        calc({b, c})

      true ->
        {:error, "nyama realni koreni"}
    end
  end

  def quadratic_case({a, b, c}) do
    case {a, b, c} do
      {0, _, _} -> calc({b, c})
      {a, b, c} when b * b >= 4 * a * c -> calc({a, b, c})
      true -> {:error, "nyama realni koreni"}
    end
  end

  def quadratic_check({a, b, c}) do
    cond do
      b * b >= 4 * a * c and a != 0 -> {a, b, c}
      a == 0 -> {b, c}
      true -> {:error, "nyama realni koreni"}
    end
  end

  def quadratic_with(params) do
    with params when is_tuple(params) <- quadratic_check(params),
         result when is_tuple(params) <- calc(params) do
      {params, result}
    else
      err -> {:error, "nyama realni koreni"}
    end
  end
end
