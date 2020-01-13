```elixir
defmodule Webcasa.Test do
  def score_match(play, team1, team2, {team1_score, team2_score}) do
    play
    |> Map.update!(team1, fn map -> update_card(map, {team1_score, team2_score}) end)
    |> Map.update!(team2, fn map -> update_card(map, {team2_score, team1_score}) end)
  end

  def update_card(
        %{
          "gk" => gk,
          "def" => def,
          "mid" => mid,
          "atk" => atk
        },
        {me, oponent}
      ) do
    %{
      "gk" => update_field(gk, -oponent),
      "def" => update_field(def, format_score(me, "def")),
      "mid" => update_field(mid, format_score(me, "mid")),
      "atk" => update_field(atk, format_score(me, "atk"))
    }
  end

  def update_field(data, score) do
    data
    |> Tuple.delete_at(3)
    |> Tuple.insert_at(3, score)
  end

  def format_score(score, pos) when pos in ["def", "mid"] and score <= 2, do: 0
  def format_score(3, "mid"), do: 1
  def format_score(3, "def"), do: 0
  def format_score(4, pos) when pos in ["def", "mid"], do: 1
  def format_score(score, "atk") when score <= 2, do: score
  def format_score(_score, "atk"), do: 2
end
```
