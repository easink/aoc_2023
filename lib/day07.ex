defmodule AoC.Day07 do
  @moduledoc false

  @cards ~c"23456789TJQKA"

  def part1(filename) do
    filename
    |> parse(&card_map1/1)
    |> winnings()
  end

  def part2(filename) do
    filename
    |> parse(&card_map2/1)
    |> winnings()
  end

  def winnings(data) do
    data
    |> Enum.sort_by(&mapper/1)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_hand, _type, bid}, idx} -> idx * bid end)
    |> Enum.sum()
  end

  defp parse(filename, card_map_fun) do
    cards = Enum.map(@cards, &card_map_fun.(&1))

    filename
    |> File.stream!()
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [hand, bid] ->
      hand = hand |> String.to_charlist() |> Enum.map(&card_map_fun.(&1))
      {hand, type(cards, hand), String.to_integer(bid)}
    end)
  end

  defp type(cards, hand) do
    cards
    |> Enum.map(fn c -> {c, count(hand, c)} end)
    |> Enum.sort_by(fn {_c, n} -> n end, :desc)
    |> case do
      [{_a, 5} | _] -> 6
      [{_a, 4} | _] -> 5 + n_jokers(hand)
      [{_a, 3}, {_b, 2} | _] -> 4 + n_jokers(hand)
      [{_a, 3} | _] -> 3 + n_jokers(hand, 1)
      [{_a, 2}, {_b, 2} | _] -> 2 + n_jokers(hand, 1)
      [{_a, 2} | _] -> Enum.at([1, 3, 5], n_jokers(hand))
      _ -> Enum.at([0, 1, 3, 5, 6, 6], n_jokers(hand))
    end
  end

  defp n_jokers(hand, i \\ 0) do
    # val = :proplists.get_value(?1, hand, 0)
    val = Enum.count(hand, fn c -> c == ?1 end)
    if val > 0, do: val + i, else: 0
  end

  defp mapper({a, b, _}), do: {b, a}

  defp count(_hand, ?1), do: 0
  defp count(hand, card), do: Enum.count(hand, fn c -> c == card end)

  defp card_map2(?T), do: ?A
  defp card_map2(?J), do: ?1
  defp card_map2(?Q), do: ?C
  defp card_map2(?K), do: ?D
  defp card_map2(?A), do: ?E
  defp card_map2(c), do: c

  defp card_map1(?T), do: ?A
  defp card_map1(?J), do: ?B
  defp card_map1(?Q), do: ?C
  defp card_map1(?K), do: ?D
  defp card_map1(?A), do: ?E
  defp card_map1(c), do: c
end
