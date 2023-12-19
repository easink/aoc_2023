defmodule AoC.Day15 do
  @moduledoc false

  def part1(filename) do
    filename
    |> parse()
    |> Enum.map(&hash(&1, 0))
    |> Enum.sum()
  end

  def part2(filename) do
    filename
    |> parse()
    |> parse_operations()
    |> operate()
    |> calculate()
  end

  defp calculate(boxes) do
    boxes
    |> Enum.map(fn
      {_box, []} ->
        0

      {box, lenses} ->
        lenses
        |> Enum.with_index(1)
        |> Enum.map(fn {{_op, n}, i} -> (box + 1) * i * n end)
        |> Enum.sum()
    end)
    |> Enum.sum()
  end

  defp operate(ops) do
    boxes = for box <- 0..255, into: %{}, do: {box, []}
    operate(ops, boxes)
  end

  defp operate([], boxes), do: boxes

  defp operate([{op, :subtract} | ops], boxes) do
    box = hash(op)
    lenses = Enum.reject(boxes[box], fn {a_op, _n} -> a_op == op end)
    operate(ops, %{boxes | box => lenses})
  end

  defp operate([{op, n} | ops], boxes) do
    box = hash(op)
    lenses = boxes[box]

    lenses =
      boxes[box]
      |> Enum.find_index(fn {a_op, _n} -> a_op == op end)
      |> case do
        nil -> lenses ++ [{op, n}]
        i -> List.replace_at(lenses, i, {op, n})
      end

    operate(ops, %{boxes | box => lenses})
  end

  defp hash(string, val \\ 0)
  defp hash(<<>>, val), do: val

  defp hash(<<a>> <> string, val) do
    hash(string, rem((val + a) * 17, 256))
  end

  defp parse_operations(ops) do
    Enum.map(ops, fn op ->
      case String.split(op, ["=", "-"]) do
        [op, ""] -> {op, :subtract}
        [op, num] -> {op, String.to_integer(num)}
      end
    end)
  end

  defp parse(filename) do
    filename
    |> File.read!()
    |> String.trim_trailing()
    |> String.split(",")
  end
end
