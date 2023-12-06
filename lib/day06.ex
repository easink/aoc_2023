defmodule AoC.Day06 do
  @moduledoc false

  def part1(filename) do
    filename
    |> parse1()
    |> races()
    |> Enum.product()
  end

  def part2(filename) do
    filename
    |> parse2()
    |> races()
    |> List.first()
  end

  defp races(races, global_wins \\ [])
  defp races([], global_wins), do: global_wins

  defp races([{time, len} | races], global_wins) do
    wins =
      1..time
      |> Enum.map(fn t -> (time - t) * t end)
      |> Enum.filter(fn s -> s > len end)
      |> length()

    races(races, [wins | global_wins])
  end

  defp parse1(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.split/1)
    |> Enum.zip()
    |> Kernel.tl()
    |> Enum.map(fn {a, b} -> {String.to_integer(a), String.to_integer(b)} end)
  end

  defp parse2(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.split/1)
    |> Enum.map(&Kernel.tl/1)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [t, l] -> [{t, l}] end)
  end
end
