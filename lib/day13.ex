defmodule AoC.Day13 do
  @moduledoc false

  def part1(filename) do
    filename
    |> parse()
    |> Enum.map(&max/1)
    |> Enum.map(&find_mirror/1)
    |> Enum.map(fn {v, h} -> v + h * 100 end)
    |> Enum.sum()
  end

  def part2(filename) do
    filename
    |> parse()
    |> Enum.map(&max/1)
    |> Enum.map(&find_mirror_with_smudge/1)
    |> Enum.map(fn {v, h} -> v + h * 100 end)
    |> Enum.sum()
  end

  defp find_mirror_with_smudge(mirror) do
    {block, max_y, max_x} = mirror
    {ov, oh} = find_mirror(mirror)

    for(y <- 1..max_y, x <- 1..max_x, do: {y, x})
    |> Enum.find_value(fn {y, x} ->
      pos = {y, x}
      smudged_block = smudged_block(block, pos)

      {v, h} = find_mirror({smudged_block, max_y, max_x}, {ov, oh})

      cond do
        v != 0 and ov != v -> {v, 0}
        h != 0 and oh != h -> {0, h}
        true -> false
      end
    end)
  end

  defp smudged_block(block, pos) do
    if pos in block, do: block -- [pos], else: block ++ [pos]
  end

  defp find_mirror({block, max_y, max_x}, {ign_v, ign_h} \\ {0, 0}) do
    {find_vertical(block, ign_v, max_x), find_horizon(block, ign_h, max_y)}
  end

  defp find_vertical(block, ign, max_x) do
    1..max_x
    |> Enum.map(fn v ->
      block
      |> Enum.filter(fn {_y, x} -> x == v end)
      |> Enum.map(fn {y, _x} -> y end)
      |> Enum.sort()
    end)
    |> find(ign)
  end

  defp find_horizon(block, ign, max_y) do
    1..max_y
    |> Enum.map(fn h ->
      block
      |> Enum.filter(fn {y, _x} -> y == h end)
      |> Enum.map(fn {_y, x} -> x end)
      |> Enum.sort()
    end)
    |> find(ign)
  end

  defp mirror?([], _rev), do: true
  defp mirror?(_sorted, []), do: true
  defp mirror?([a | sorted], [a | rev]), do: mirror?(sorted, rev)
  defp mirror?(_sorted, _rev), do: false

  defp find(sorted, ign, rev \\ [], idx \\ 1)

  defp find([a, a | sorted], ign, rev, idx) do
    if ign != idx and mirror?(sorted, rev) do
      idx
    else
      find([a | sorted], ign, [a | rev], idx + 1)
    end
  end

  defp find([_a], _ign, _rev, _idx), do: 0

  defp find([a, b | sorted], ign, rev, idx) do
    find([b | sorted], ign, [a | rev], idx + 1)
  end

  defp max(block) do
    {max_y, _x} = block |> Enum.max_by(fn {y, _x} -> y end)
    {_y, max_x} = block |> Enum.max_by(fn {_y, x} -> x end)
    {block, max_y, max_x}
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.chunk_by(&(&1 != ""))
    |> Enum.filter(&(&1 != [""]))
    |> Enum.map(&parse_block/1)
  end

  defp parse_block(list) do
    list
    |> Enum.with_index(1)
    |> Enum.reduce([], fn {line, y}, acc ->
      line
      |> String.to_charlist()
      |> Enum.with_index(1)
      |> Enum.reduce(acc, fn
        {?., _x}, acc -> acc
        {_char, x}, acc -> [{y, x} | acc]
      end)
    end)
  end
end
