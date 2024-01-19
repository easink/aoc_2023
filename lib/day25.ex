defmodule AoC.Day25 do
  @moduledoc """
  """

  def part1(filename) do
    filename
    |> parse()
    |> stoer_wagner()
    |> Enum.product()
  end

  def dottify(filename) do
    IO.puts("graph {")

    for {a, b} <- parse(filename) do
      for {c, _w} <- b do
        IO.puts("#{a} -- #{c}")
      end
    end

    IO.puts("}")
  end

  defp stoer_wagner(edges) do
    {a, _as} = Enum.random(edges)

    {vs, _w} = minimum_cut(edges, a, nil, :infinity)
    [map_size(edges) - length(vs), length(vs)]
  end

  defp minimum_cut_phase(edges, a, been) when map_size(edges) == 2 do
    [{b, w}] = edges[a] |> Map.to_list()
    been = [b | been]
    [t, s | _been] = been
    {s, t, w}
  end

  defp minimum_cut_phase(edges, a, been) do
    {adjacent, _w} = edges[a] |> Enum.max_by(fn {_n, w} -> w end)
    new_edges = contract(edges, a, adjacent)
    new_a = [a, adjacent]
    minimum_cut_phase(new_edges, new_a, [adjacent | been])
  end

  defp minimum_cut(edges, _a, best_t, min_w) when map_size(edges) == 1 do
    {List.flatten(best_t), min_w}
  end

  # optimized for this day
  defp minimum_cut(_edges, _a, best_t, 3) do
    {List.flatten(best_t), 3}
  end

  defp minimum_cut(edges, a, best_t, min_w) do
    {s, t, w} = minimum_cut_phase(edges, a, [a])
    new_edges = contract(edges, s, t)

    if w < min_w do
      minimum_cut(new_edges, a, t, w)
    else
      minimum_cut(new_edges, a, best_t, min_w)
    end
  end

  defp contract(edges, s, t) do
    ss = edges[s] |> Map.delete(t)
    ts = edges[t] |> Map.delete(s)

    st = [s, t]
    sts = Map.merge(ss, ts, fn _key, sv, tv -> sv + tv end)

    Enum.reduce(sts, edges, fn {x, xw}, acc ->
      xs =
        acc[x]
        |> Map.delete(s)
        |> Map.delete(t)
        |> Map.put(st, xw)

      Map.put(acc, x, xs)
    end)
    |> Map.delete(s)
    |> Map.delete(t)
    |> Map.put(st, sts)
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.map(&String.split(&1, [": ", " "]))
    |> Enum.reduce(%{}, &parse_row/2)
  end

  defp parse_row([a | list], acc) do
    a = [String.to_atom(a)]

    Enum.reduce(list, acc, fn b, acc ->
      b = [String.to_atom(b)]

      acc
      |> Map.update(a, %{b => 1}, fn amap -> Map.put(amap, b, 1) end)
      |> Map.update(b, %{a => 1}, fn bmap -> Map.put(bmap, a, 1) end)
    end)
  end

  # defp stor_test() do
  #   %{
  #     a: %{f: 4, b: 5, e: 1},
  #     b: %{a: 5, c: 2},
  #     c: %{b: 2, f: 1, e: 1, d: 6},
  #     d: %{c: 6, e: 3},
  #     e: %{a: 1, c: 1, d: 3},
  #     f: %{a: 4, c: 1}
  #   }
  # end
end
