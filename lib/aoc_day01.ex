defmodule AoC.Day01 do
  @moduledoc false

  def part1(filename) do
    filename
    |> parse1()
    |> Enum.sum()
  end

  def part2(filename) do
    filename
    |> parse2()
    |> Enum.sum()
  end

  defp parse1(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&parse_line1/1)
  end

  defp parse2(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&parse_line/1)
  end

  defp parse_line1(line) do
    integers =
      line
      |> String.trim()
      |> String.to_charlist()
      |> Enum.filter(fn x -> ?0 <= x and x <= ?9 end)
      |> Enum.map(fn x -> x - ?0 end)

    List.first(integers) * 10 + List.last(integers)
  end

  defp parse_line(line), do: parse_line(String.to_charlist(line), [])
  defp parse_line([], line), do: List.last(line) * 10 + List.first(line)
  defp parse_line([x | rest], line) when ?0 <= x and x <= ?9, do: parse_line(rest, [x - ?0 | line])
  defp parse_line('one' ++ rest, line), do: parse_line(rest, [1 | line])
  defp parse_line('two' ++ rest, line), do: parse_line(rest, [2 | line])
  defp parse_line('three' ++ rest, line), do: parse_line(rest, [3 | line])
  defp parse_line('four' ++ rest, line), do: parse_line(rest, [4 | line])
  defp parse_line('five' ++ rest, line), do: parse_line(rest, [5 | line])
  defp parse_line('six' ++ rest, line), do: parse_line(rest, [6 | line])
  defp parse_line('seven' ++ rest, line), do: parse_line(rest, [7 | line])
  defp parse_line('eight' ++ rest, line), do: parse_line(rest, [8 | line])
  defp parse_line('nine' ++ rest, line), do: parse_line(rest, [9 | line])
  defp parse_line([_ | rest], line), do: parse_line(rest, line)
end
