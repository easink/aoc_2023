defmodule AoC.Day10 do
  @moduledoc false

  def part1(filename) do
    filename
    |> parse()
    |> walk()
    |> half_way()
  end

  def part2(filename) do
    filename
    |> parse()
    |> walk()
    |> find_inner()
    |> elem(2)
  end

  defp find_inner({map, path}) do
    path
    |> ranges()
    |> Enum.sort()
    |> Enum.reduce({{0, 0}, :outer, 0}, fn {y, x1, x2}, {{pos_y, pos_x}, toggle, counter} ->
      toggle = if y != pos_y, do: :outer, else: toggle
      c1 = map[{y, x1}]
      c2 = map[{y, x2}]

      cond do
        toggle == :inner and {c1, c2} == {?F, ?7} -> {{y, x2}, :inner, counter + (x1 - pos_x - 1)}
        toggle == :outer and {c1, c2} == {?F, ?7} -> {{y, x2}, :outer, counter}
        toggle == :inner and {c1, c2} == {?L, ?J} -> {{y, x2}, :inner, counter + (x1 - pos_x - 1)}
        toggle == :outer and {c1, c2} == {?L, ?J} -> {{y, x2}, :outer, counter}
        toggle == :inner -> {{y, x2}, :outer, counter + (x1 - pos_x - 1)}
        toggle == :outer -> {{y, x2}, :inner, counter}
      end
    end)
  end

  defp ranges([{start_y, start_x} | path]) do
    ranges(path, start_y, start_x, start_x, [])
  end

  defp ranges([], y, min_x, max_x, acc), do: [{y, min_x, max_x} | acc]

  defp ranges([{pos_y, pos_x} | path], y, min_x, max_x, acc) do
    cond do
      pos_y != y ->
        ranges(path, pos_y, pos_x, pos_x, [{y, min_x, max_x} | acc])

      pos_x == min_x - 1 ->
        ranges(path, y, pos_x, max_x, acc)

      pos_x == max_x + 1 ->
        ranges(path, y, min_x, pos_x, acc)
    end
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    # |> Enum.map(&String.split/1)
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn
        {?., _x}, acc -> acc
        {?S, x}, acc -> Map.put(acc, :start, {y, x})
        {char, x}, acc -> Map.put(acc, {y, x}, char)
      end)
    end)
  end

  @valid_moves %{
    {:down, ?|} => :down,
    {:up, ?|} => :up,
    {:left, ?-} => :left,
    {:right, ?-} => :right,
    {:down, ?L} => :right,
    {:left, ?L} => :up,
    {:right, ?J} => :up,
    {:down, ?J} => :left,
    {:right, ?7} => :down,
    {:up, ?7} => :left,
    {:up, ?F} => :right,
    {:left, ?F} => :down
  }

  defp walk(map) do
    start_pos = map[:start]

    Map.keys(@valid_moves)
    |> Stream.map(fn {dir, start_pipe} ->
      next_dir = @valid_moves[{dir, start_pipe}]
      next_pos = next_pos(start_pos, next_dir)

      map
      |> Map.put(start_pos, start_pipe)
      |> walk(next_pos, next_dir, start_pos, start_pipe, [])
    end)
    |> Stream.reject(fn x -> x == :error end)
    |> Enum.take(1)
    |> hd()
  end

  defp half_way({_map, n_steps}), do: div(length(n_steps) + 1, 2)
  defp walk(_map, nil, _dir, _start_pos, _start_pipe, _steps), do: :error

  defp walk(map, start_pos, dir, start_pos, start_pipe, steps) do
    if @valid_moves[{dir, start_pipe}],
      do: {map, [start_pos | steps]},
      else: :error
  end

  defp walk(map, pos, dir, start_pos, start_pipe, steps) do
    pipe = map[pos]
    next_dir = @valid_moves[{dir, pipe}]
    next_pos = next_pos(pos, next_dir)
    walk(map, next_pos, next_dir, start_pos, start_pipe, [pos | steps])
  end

  defp next_pos(_, nil), do: nil

  defp next_pos({y, x}, dir) do
    case dir do
      :up -> {y - 1, x}
      :down -> {y + 1, x}
      :left -> {y, x - 1}
      :right -> {y, x + 1}
    end
  end
end
