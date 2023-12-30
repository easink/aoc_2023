defmodule AoC.Day18 do
  @moduledoc """
  using beautiful shoelace formula
  needed to include the outline
  """

  @up {0, -1}
  @down {0, 1}
  @left {-1, 0}
  @right {1, 0}

  @directions %{
    "R" => @right,
    "L" => @left,
    "U" => @up,
    "D" => @down
  }

  def part1(filename) do
    {coords, outline} =
      filename
      |> parse_p1()
      |> walk()

    area(coords) + outline
  end

  def part2(filename) do
    {coords, outline} =
      filename
      |> parse_p2()
      |> walk()

    area(coords) + outline
  end

  defp area([pos | coords]) do
    coords
    |> shoelace(pos, 0)
    |> abs()
  end

  defp shoelace([], _pos, area), do: div(area, 2)

  defp shoelace([next_pos | coords], pos, area) do
    shoelace(coords, next_pos, area + det(pos, next_pos))
  end

  defp det({x1, y1}, {x2, y2}) do
    x1 * y2 - x2 * y1
    # (y1 + y2) * (x1 - x2)
  end

  defp walk(commands), do: walk(commands, {0, 0}, 0, [{0, 0}])

  defp walk([], _pos, outline, coords), do: {coords, div(outline, 2) + 1}

  defp walk([{dir, steps} | commands], pos, outline, coords) do
    new_pos = mul(pos, @directions[dir], steps)
    walk(commands, new_pos, outline + steps, [new_pos | coords])
  end

  defp mul({x, y}, {xd, yd}, n), do: {x + xd * n, y + yd * n}

  defp parse_p1(filename) do
    filename
    |> parse()
    |> Enum.map(fn {dir, steps, _, _} -> {dir, steps} end)
  end

  defp parse_p2(filename) do
    filename
    |> parse()
    |> Enum.map(fn {_, _, dir, steps} -> {dir, steps} end)
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse_row/1)
  end

  @dir %{?0 => "R", ?1 => "D", ?2 => "L", ?3 => "U"}

  defp parse_row([dir, steps, <<"(", "#", steps2::binary-size(5), dir2, ")">>]) do
    {
      dir,
      String.to_integer(steps),
      @dir[dir2],
      String.to_integer(steps2, 16)
    }
  end
end
