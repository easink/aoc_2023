defmodule AoC.Day04 do
  @moduledoc false

  def part1(filename) do
    filename
    |> parse()
    |> Enum.map(fn x ->
      case x do
        0 -> 0
        n -> Bitwise.<<<(1, n - 1)
      end
    end)
    |> Enum.sum()
  end

  def part2(filename) do
    filename
    |> parse()
    |> calc_cards()
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&split_card/1)
  end

  defp calc_cards(cards) do
    copies = for _i <- 1..length(cards), do: 1
    calc_cards(cards, copies, [])
  end

  defp calc_cards([], _copies, n), do: Enum.sum(n)

  defp calc_cards([a | cards], [c | copies], n) do
    copies = add_copies(a, c, copies)
    calc_cards(cards, copies, [c | n])
  end

  defp add_copies(0, _x, copies), do: copies
  defp add_copies(i, x, [c | copies]), do: [c + x | add_copies(i - 1, x, copies)]

  defp split_card(line) do
    ["Card " <> _game_id, numbers_line] =
      line
      |> String.trim_trailing()
      |> String.split(":")

    numbers_line
    |> String.split(" | ")
    |> Enum.map(fn nums ->
      nums
      |> String.trim_leading()
      |> String.split(~r/ +/)
      |> Enum.map(&to_int/1)
      |> MapSet.new()
    end)
    |> then(fn [w, n] -> MapSet.intersection(w, n) end)
    |> MapSet.size()
  end

  defp to_int(str) do
    str |> String.trim_leading() |> String.to_integer()
  end
end
