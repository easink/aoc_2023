defmodule AoC.Day22 do
  @moduledoc """
  slow and naive, will take around 5m
  """

  def part1(filename) do
    filename
    |> parse()
    |> stabilize()
    |> disintegrated()
    |> Enum.count()
  end

  def part2(filename) do
    filename
    |> parse()
    |> stabilize()
    |> bricks_to_fall()
    |> Enum.count()
  end

  defp bricks_to_fall(bricks) do
    disintegrated = bricks -- disintegrated(bricks)

    disintegrated
    |> Enum.map(&bricks_to_fall(bricks, &1))
    |> List.flatten()
  end

  defp bricks_to_fall(bricks, falling) do
    bricks
    |> Enum.sort_by(fn {_x, _y, z.._z2} -> z end)
    |> Enum.reduce([falling], fn {x, y, z} = brick, f_acc ->
      new_brick = {x, y, Range.shift(z, -1)}

      coll_bricks = Enum.filter(bricks, fn b -> collision?(new_brick, b) end)

      case coll_bricks -- [brick | f_acc] do
        [] -> [brick | f_acc]
        _coll -> f_acc
      end
    end)
    |> List.delete(falling)
  end

  defp disintegrated(bricks) do
    bricks
    |> Enum.reduce([], fn {x, y, z} = brick, acc ->
      new_brick = {x, y, Range.shift(z, -1)}
      coll_bricks = Enum.filter(bricks, fn b -> collision?(new_brick, b) end)
      coll_bricks = coll_bricks -- [brick]
      if length(coll_bricks) == 1, do: coll_bricks ++ acc, else: acc
    end)
    |> Enum.dedup()
    |> then(fn coll_bricks -> bricks -- coll_bricks end)
  end

  defp stabilize(bricks) do
    bricks
    |> Enum.sort_by(fn {_x, _y, z.._z2} -> z end)
    |> Enum.reduce(bricks, fn brick, bricks_acc ->
      bricks_acc = bricks_acc -- [brick]
      new_brick = stabilize(brick, bricks_acc)
      [new_brick | bricks_acc]
    end)
  end

  defp stabilize({x, y, z} = brick, bricks) do
    new_brick = {x, y, Range.shift(z, -1)}

    if Enum.any?(bricks, fn b -> collision?(new_brick, b) end) do
      brick
    else
      stabilize(new_brick, bricks)
    end
  end

  defp collision?({_x, _y, 0.._z}, _with), do: true

  defp collision?({x1, y1, z1}, {x2, y2, z2}) do
    not Range.disjoint?(x1, x2) and not Range.disjoint?(y1, y2) and not Range.disjoint?(z1, z2)
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.map(&String.split(&1, [",", "~"]))
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(6)
    |> Enum.map(fn [a, b, c, d, e, f] ->
      {min(a, d)..max(a, d), min(b, e)..max(b, e), min(c, f)..max(c, f)}
    end)
  end
end
