defmodule AoC.Day17 do
  @moduledoc """
  when using ordinary list for pq it took 12 sec to complete.
  when using gb_sets for pq it took 1.2 sec to complete.

  part2 finished in 5.7s.
  """

  @north {0, -1}
  @south {0, 1}
  @west {-1, 0}
  @east {1, 0}

  def part1(input) do
    graph = parse(input)
    target = max_coord(graph)

    graph
    |> dijkstra({0, 0}, 1, 3)
    |> Enum.filter(fn {{pos, _dir, _dirlen}, _cost} -> pos == target end)
    |> Enum.map(fn {{_pos, _dir, _dirlen}, cost} -> cost end)
    |> Enum.min()
  end

  def part2(input) do
    graph = parse(input)
    target = max_coord(graph)

    graph
    |> dijkstra({0, 0}, 4, 10)
    |> Enum.filter(fn {{pos, _dir, _dirlen}, _cost} -> pos == target end)
    |> Enum.filter(fn {{_pos, _dir, dirlen}, _cost} -> dirlen >= 4 end)
    |> Enum.map(fn {{_pos, _dir, _dirlen}, cost} -> cost end)
    |> Enum.min()
  end

  defp dijkstra(graph, source, min, max) do
    source_s = {source, @south, 0}
    source_e = {source, @east, 0}

    priority_queue =
      [
        {0, source_s},
        {0, source_e}
      ]
      |> :gb_sets.from_list()

    distance = %{
      source_s => 0,
      source_e => 0
    }

    dijkstra_traverse({distance, priority_queue}, graph, min, max)
  end

  @pq_empty :gb_sets.new()

  # defp dijkstra_traverse({distance, []}, _graph), do: distance
  defp dijkstra_traverse({distance, @pq_empty}, _graph, _min, _max), do: distance

  defp dijkstra_traverse({distance, priority_queue}, graph, min, max) do
    # {cost, vertex} = item = Enum.min(priority_queue)
    # priority_queue = priority_queue -- [item]
    {{cost, vertex}, priority_queue} = :gb_sets.take_smallest(priority_queue)

    vertex_neighbours(vertex, graph, min, max)
    |> Enum.reduce({distance, priority_queue}, fn neighbour, {distance_acc, pq_acc} ->
      {pos, _dir, _dirlen} = neighbour
      new_cost = cost + graph[pos]

      if new_cost < Map.get(distance_acc, neighbour, :infinity) do
        {
          Map.put(distance_acc, neighbour, new_cost),
          # [{new_cost, neighbour} | pq_acc]
          :gb_sets.add({new_cost, neighbour}, pq_acc)
        }
      else
        {distance_acc, pq_acc}
      end
    end)
    |> dijkstra_traverse(graph, min, max)
  end

  defp vertex_neighbours({pos, dir, dirlen}, graph, min, max) do
    [@north, @south, @west, @east]
    # ignore opposite direction
    |> Enum.reject(fn new_dir -> opposite_dir?(new_dir, dir) end)
    # dont turn on to short
    |> Enum.reject(fn new_dir -> new_dir != dir and dirlen < min end)
    |> Enum.map(fn
      new_dir when new_dir == dir -> {vertex_add(pos, dir), dir, dirlen + 1}
      new_dir -> {vertex_add(pos, new_dir), new_dir, 1}
    end)
    # ignore if to long
    |> Enum.reject(fn {_pos, _dir, new_dirlen} -> new_dirlen > max end)
    # ignore if out of bounds
    |> Enum.filter(fn {pos, _dir, _dirlen} -> graph[pos] end)
  end

  defp opposite_dir?(dir, {xd, yd}), do: dir == {-xd, -yd}

  defp vertex_add({x, y}, {xd, yd}), do: {x + xd, y + yd}

  defp parse(input) do
    input
    |> String.split()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {x_line, y_index}, acc ->
      x_line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {value, x_index}, x_acc ->
        Map.put(x_acc, {x_index, y_index}, String.to_integer(value))
      end)
    end)
  end

  def max_coord(graph) do
    graph
    |> Map.keys()
    |> Enum.reduce({0, 0}, fn {a, b}, {x, y} -> {max(a, x), max(b, y)} end)
  end
end
