defmodule AoC.Day23 do
  @moduledoc """
  """

  @north {0, -1}
  @south {0, 1}
  @west {-1, 0}
  @east {1, 0}

  def part1(filename) do
    filename
    |> parse()
    |> dfs()
  end

  def part2(filename) do
    filename
    |> parse()
    |> dfs2()
  end

  defp find_source(vertices) do
    Enum.min_by(vertices, fn {_x, y} -> y end)
  end

  defp find_target(vertices) do
    Enum.max_by(vertices, fn {_x, y} -> y end)
  end

  defp dfs2(nodes) do
    verticies = Map.keys(nodes)
    source = find_source(verticies)
    target = find_target(verticies)

    graph = build_graph(source, source, source, target, nodes, %{}, 0)

    dfs_walk2(source, target, graph, [], 0, 0)
  end

  defp dfs_walk2(target, target, _graph, _been, n, max), do: max(n, max)

  defp dfs_walk2(source, target, graph, been, n, max) do
    find_edges(graph, source, been)
    |> Enum.reduce(max, fn {weight, next}, acc ->
      dfs_walk2(next, target, graph, [source | been], n + weight, acc)
    end)
  end

  defp find_edges(graph, source, been) do
    graph
    |> Enum.filter(fn {{min, max}, _n} -> min == source or max == source end)
    |> Enum.reject(fn {{min, max}, _n} -> min in been or max in been end)
    |> Enum.map(fn
      {{^source, max}, n} -> {n, max}
      {{min, ^source}, n} -> {n, min}
    end)
  end

  defp dfs(graph) do
    verticies = Map.keys(graph)
    source = find_source(verticies)
    target = find_target(verticies)

    dfs_walk(source, target, graph, [], 0)
  end

  defp dfs_walk(target, target, _graph, _been, n), do: n

  defp dfs_walk(vertex, target, graph, been, n) do
    vertex_neighbours(vertex, graph, been)
    |> Enum.map(&dfs_walk(&1, target, graph, [vertex | been], n + 1))
    |> Enum.max(fn -> n end)
  end

  defp vertex_edges(vertex, nodes, prev) do
    north = vertex_add(vertex, @north)
    south = vertex_add(vertex, @south)
    west = vertex_add(vertex, @west)
    east = vertex_add(vertex, @east)

    [north, south, west, east]
    |> Enum.reject(&(&1 == prev))
    |> Enum.filter(&(&1 in Map.keys(nodes)))
  end

  defp vertex_neighbours(vertex, graph, been) do
    val = graph[vertex]
    north = vertex_add(vertex, @north)
    south = vertex_add(vertex, @south)
    west = vertex_add(vertex, @west)
    east = vertex_add(vertex, @east)

    case val do
      "<" -> [west]
      ">" -> [east]
      "^" -> [north]
      "v" -> [south]
      "." -> [north, south, west, east]
    end
    |> Enum.reject(&(&1 in been))
    |> Enum.filter(&(&1 in Map.keys(graph)))
    |> Enum.reject(fn v ->
      next = graph[v]

      (v == north and next == "v") or (v == south and next == "^") or
        (v == west and next == ">") or (v == east and next == "<")
    end)
  end

  defp vertex_add({x, y}, {xd, yd}), do: {x + xd, y + yd}

  defp parse(filename) do
    filename
    |> File.read!()
    |> String.split()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {x_line, y_index}, acc ->
      x_line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn
        {"#", _x_index}, acc ->
          acc

        {val, x_index}, acc ->
          Map.put(acc, {x_index, y_index}, val)
      end)
    end)
  end

  # defp print(graph, been) do
  #   for y <- 0..22 do
  #     IO.puts("")

  #     for x <- 0..22 do
  #       cond do
  #         {x, y} in been -> IO.write("O")
  #         true -> IO.write(graph[{x, y}] || "#")
  #       end
  #     end
  #   end

  #   IO.puts("")
  # end

  def dottify(filename) do
    nodes = parse(filename)
    verticies = Map.keys(nodes)
    source = find_source(verticies)
    target = find_target(verticies)

    IO.puts("graph {")

    build_graph(source, source, source, target, nodes, %{}, 0)
    |> Enum.map(fn {{min, max}, n} ->
      IO.puts("\"#{inspect(min)}\" -- \"#{inspect(max)}\" [label=\"#{n}\"]")
    end)

    IO.puts("}")
  end

  defp build_graph(start, _prev, target, target, _nodes, edges, n) do
    Map.put(edges, {start, target}, n)
  end

  defp build_graph(start, prev, vertex, target, nodes, edges, n) do
    edge = {min(start, vertex), max(start, vertex)}

    if Map.has_key?(edges, edge) do
      edges
    else
      case vertex_edges(vertex, nodes, prev) do
        [] ->
          edges

        [v] ->
          build_graph(start, vertex, v, target, nodes, edges, n + 1)

        vs ->
          Enum.reduce(vs, edges, fn v, edges_acc ->
            build_graph(vertex, vertex, v, target, nodes, Map.put(edges_acc, edge, n), 1)
          end)
      end
    end
  end
end
