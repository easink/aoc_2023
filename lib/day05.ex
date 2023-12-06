defmodule AoC.Day05 do
  @moduledoc false

  def part1(filename) do
    {seeds, mapping} =
      filename
      |> parse()

    seed_locations =
      for seed <- seeds do
        {seed, walk(seed, "location", "seed", mapping)}
      end

    seed_locations
    |> Enum.min_by(fn {_s, l} -> l end)
    |> elem(1)
  end

  def part2(filename) do
    {seeds, mapping} =
      filename
      |> parse()

    seeds =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [s, r] -> s..(s + r - 1) end)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.find(fn location_n ->
      n = walk_back(location_n, "humidity", mapping)
      Enum.any?(seeds, fn seed_r -> n in seed_r end)
    end)
  end

  defp walk(n, target, source, mapping) do
    n = get_map(mapping[source], n)
    dest = mapping["#{source}-to"]

    if target == dest,
      do: n,
      else: walk(n, target, dest, mapping)
  end

  defp walk_back(n, target, mapping) do
    n = get_back(mapping[target], n)
    src = mapping["#{target}-from"]

    if src,
      do: walk_back(n, src, mapping),
      else: n
  end

  defp get_map([], n), do: n
  defp get_map([[d, s, r] | _ranges], n) when n in s..(s + r - 1), do: d + (n - s)
  defp get_map([_range | ranges], n), do: get_map(ranges, n)

  defp get_back([], n), do: n
  defp get_back([[d, s, r] | _ranges], n) when n in d..(d + r - 1), do: n - d + s
  defp get_back([_range | ranges], n), do: get_back(ranges, n)

  defp parse(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> parse_seeds_and_mapping()
  end

  defp parse_seeds_and_mapping([seeds | mapping]) do
    ["seeds:" | seeds] = seeds
    seeds = Enum.map(seeds, &String.to_integer/1)

    mapping = parse_mapping(%{}, mapping, "ignore", [])

    {seeds, mapping}
  end

  defp parse_mapping(data, [], cat, ranges), do: Map.put(data, cat, ranges)

  defp parse_mapping(data, [[mapname, "map:"] | mapping], cat, ranges) do
    [source, dest] = String.split(mapname, "-to-")

    data
    |> Map.put(cat, ranges)
    |> Map.put("#{source}-to", dest)
    |> Map.put("#{dest}-from", source)
    |> parse_mapping(mapping, source, [])
  end

  defp parse_mapping(data, [dsr | mapping], cat, ranges) do
    range = Enum.map(dsr, &String.to_integer/1)
    parse_mapping(data, mapping, cat, [range | ranges])
  end
end
