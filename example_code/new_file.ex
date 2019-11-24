defmodule NewFile do
  def start([lang, frame]) do
    first(%{"lang" => lang, "frame" => frame, "new" => "neu"})
  end

  def first(%{"lang" => "elixir"} = _param) do
    {:ok, "elexir as argument"}
  end

  def first(%{"lang" => "english", "frame" => _frame} = _param) do
    {:error, "Programing language"}
  end

  def first(%{"lang" => _} = _param) do
    {:ok, "One strange language"}
  end
end
