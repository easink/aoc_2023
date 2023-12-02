defmodule AoC.Day02 do
  @moduledoc false

  def part1(filename) do
    max_rolls = %{"red" => 12, "green" => 13, "blue" => 14}

    filename
    |> parse()
    |> Enum.filter(&valid_game?(&1, max_rolls))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def part2(filename) do
    filename
    |> parse()
    |> Enum.map(&game_power/1)
    |> Enum.sum()
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&parse_line/1)
    |> Enum.map(&game_max/1)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> split_game()
  end

  defp game_power(game) do
    {_game_id, rolls} = game
    Enum.reduce(rolls, 1, fn {_color, n}, power -> n * power end)
  end

  defp valid_game?(game, max_rolls) do
    {_game_id, rolls} = game

    Enum.all?(rolls, fn {color, n} ->
      n <= max_rolls[color]
    end)
  end

  defp game_max({game_id, game_rolls}) do
    max_rolls =
      Enum.reduce(game_rolls, fn rolls, max_rolls ->
        Map.merge(max_rolls, rolls, fn _color, n1, n2 ->
          max(n1, n2)
        end)
      end)

    {game_id, max_rolls}
  end

  defp split_game(line) do
    ["Game " <> game, rolls] = String.split(line, ": ")
    game_id = String.to_integer(game)

    rolls =
      rolls
      |> String.split("; ")
      |> Enum.map(&parse_rolls/1)

    {game_id, rolls}
  end

  defp parse_rolls(rolls) do
    rolls
    |> String.split(", ")
    |> Enum.map(fn roll ->
      [n, color] = String.split(roll, " ")
      n = String.to_integer(n)
      {color, n}
    end)
    |> Enum.into(%{})
  end
end
