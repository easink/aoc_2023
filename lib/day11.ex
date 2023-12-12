defmodule AoC.Day11 do
  @moduledoc false

  def part(filename, adjustment) do
    filename
    |> parse()
    |> add_empty_rows_and_cols()
    |> adjust_pos(adjustment - 1)
    |> find_distances()
  end

  defp find_distances(galaxy) do
    find_distances(galaxy, 0)
  end

  defp find_distances([], distances), do: distances

  defp find_distances([start | galaxy], distances) do
    distance =
      galaxy
      |> Enum.map(fn star -> distance(start, star) end)
      |> Enum.sum()

    find_distances(galaxy, distances + distance)
  end

  def distance({y1, x1}, {y2, x2}), do: abs(y2 - y1) + abs(x2 - x1)

  defp adjust_pos({galaxy, rows, cols}, n) do
    Enum.map(galaxy, fn {y, x} ->
      n_ys = Enum.count(rows, fn row -> y > row end)
      n_xs = Enum.count(cols, fn col -> x > col end)
      {y + n_ys * n, x + n_xs * n}
    end)
  end

  defp add_empty_rows_and_cols(galaxy) do
    cols = Enum.map(galaxy, fn {_y, x} -> x end)
    rows = Enum.map(galaxy, fn {y, _x} -> y end)
    max_x = Enum.max(cols)
    max_y = Enum.max(rows)

    {
      galaxy,
      Range.to_list(0..max_y) -- rows,
      Range.to_list(0..max_x) -- cols
    }
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, y}, acc ->
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn
        {?., _x}, acc -> acc
        {_char, x}, acc -> [{y, x} | acc]
      end)
    end)
  end
end
