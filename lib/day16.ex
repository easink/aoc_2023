defmodule AoC.Day16 do
  @moduledoc false

  def part1(filename) do
    filename
    |> parse()
    |> walk({{0, 0}, {0, 1}})
  end

  def part2(filename) do
    filename
    |> parse()
    |> walk_edge()
  end

  defp walk([], _char_map, memo), do: memo

  defp walk([beam | beams], char_map, memo) do
    next =
      beam
      |> next(char_map)
      |> Enum.filter(fn b -> valid_pos?(b, char_map) end)
      |> Enum.reject(fn b -> MapSet.member?(memo, b) end)

    memo = Enum.reduce(next, memo, fn b, m -> MapSet.put(m, b) end)

    walk(next ++ beams, char_map, memo)
  end

  defp walk(char_map, start_beam) do
    [start_beam]
    |> walk(char_map, MapSet.new([start_beam]))
    |> MapSet.to_list()
    |> Enum.map(fn {pos, _dir} -> pos end)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.count()
  end

  defp walk_edge(char_map) do
    {max_y, max_x} = max(char_map)

    [
      for(x <- 0..max_x, do: {{0, x}, {1, 0}}),
      for(x <- 0..max_x, do: {{max_y, x}, {-1, 0}}),
      for(y <- 0..max_y, do: {{y, 0}, {0, 1}}),
      for(y <- 0..max_y, do: {{y, max_x}, {0, -1}})
    ]
    |> List.flatten()
    |> Enum.map(fn beam -> walk(char_map, beam) end)
    |> Enum.max()
  end

  defp max(char_map) do
    positions = Map.keys(char_map)
    {max_y, _x} = positions |> Enum.max_by(fn {y, _x} -> y end)
    {_y, max_x} = positions |> Enum.max_by(fn {_y, x} -> x end)
    {max_y, max_x}
  end

  defp valid_pos?({pos, _dir}, char_map), do: char_map[pos]

  defp next({pos, dir}, char_map) do
    case {dir, char_map[pos]} do
      {_dir, nil} ->
        []

      {{y, x}, ?/} ->
        [add_dir(pos, {-x, -y})]

      {{y, x}, ?\\} ->
        [add_dir(pos, {x, y})]

      {{0, _x}, ?-} ->
        [add_dir(pos, dir)]

      {{_y, 0}, ?-} ->
        [add_dir(pos, {0, -1}), add_dir(pos, {0, 1})]

      {{0, _x}, ?|} ->
        [add_dir(pos, {-1, 0}), add_dir(pos, {1, 0})]

      {{_y, 0}, ?|} ->
        [add_dir(pos, dir)]

      {_dir, ?.} ->
        [add_dir(pos, dir)]
    end
  end

  defp add_dir({y, x}, {n, m}), do: {{y + n, x + m}, {n, m}}

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> parse_block()
  end

  defp parse_block(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, char_map ->
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(char_map, fn
        {char, x}, char_map -> Map.put(char_map, {y, x}, char)
      end)
    end)
  end
end
