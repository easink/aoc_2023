defmodule AoC.Day09 do
  @moduledoc false

  def part1(filename) do
    filename
    |> parse()
    |> Enum.map(fn {n, _m} -> n end)
    |> Enum.sum()
  end

  def part2(filename) do
    filename
    |> parse()
    |> Enum.map(fn {_n, m} -> m end)
    |> Enum.sum()
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.split/1)
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
    |> Enum.map(&gen_diffs([&1]))
    |> Enum.map(&gen_next(&1))
  end

  defp gen_next(acc), do: gen_next(acc, 0, 0)
  defp gen_next([], n, m), do: {n, m}

  defp gen_next([a | acc], n, m),
    do: gen_next(acc, List.last(a) + n, List.first(a) - m)

  defp gen_diffs([a | _] = list) do
    if Enum.all?(a, fn i -> i == 0 end),
      do: list,
      else: gen_diffs([gen_diff(a) | list])
  end

  defp gen_diff(list, acc \\ [])
  defp gen_diff([_], acc), do: Enum.reverse(acc)

  defp gen_diff([a, b | data], acc),
    do: gen_diff([b | data], [b - a | acc])
end
