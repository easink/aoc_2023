defmodule AoC.Day08 do
  @moduledoc false

  def part1(filename) do
    filename
    |> parse()
    |> find_way("AAA", "ZZZ")
  end

  def part2(filename) do
    filename
    |> parse()
    |> find_way2("A", "Z")
    |> Enum.reduce(1, fn a, acc -> lcm(a, acc) end)
  end

  defp find_way({direction, mapping}, starts_with, ends_with) do
    direction
    |> Stream.cycle()
    |> Enum.reduce_while({starts_with, 0}, fn dir, {pos, counter} ->
      if String.ends_with?(pos, ends_with),
        do: {:halt, counter},
        else: {:cont, {new_pos(pos, dir, mapping), counter + 1}}
    end)
  end

  defp find_way2({_, mapping} = data, starts_with, ends_with) do
    mapping
    |> :proplists.get_keys()
    |> Enum.filter(&String.ends_with?(&1, starts_with))
    |> Enum.map(&find_way(data, &1, ends_with))
  end

  defp lcm(a, b), do: div(a * b, Integer.gcd(a, b))

  defp new_pos(pos, direction, mapping) do
    value = :proplists.get_value(pos, mapping)

    case {direction, value} do
      {?L, {l, _r}} -> l
      {?R, {_l, r}} -> r
    end
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.split/1)
    |> map()
  end

  defp map([[direction], [] | mapping]) do
    direction = String.to_charlist(direction)

    mapping =
      mapping
      |> Enum.map(fn [a, "=", b, c] ->
        b = b |> String.trim_leading("(") |> String.trim_trailing(",")
        c = c |> String.trim_trailing(")")
        {a, {b, c}}
      end)

    {direction, mapping}
  end
end
