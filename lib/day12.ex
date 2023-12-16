defmodule AoC.Day12 do
  @moduledoc false

  def part1(filename) do
    filename
    |> parse()
    |> Enum.map(&arr/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def part2(filename) do
    filename
    |> parse()
    |> Enum.map(fn {group, ns} ->
      {
        group
        |> List.duplicate(5)
        |> Enum.intersperse(??)
        |> List.flatten(),
        ns
        |> List.duplicate(5)
        |> List.flatten()
      }
    end)
    |> Enum.map(&arr/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp arr([], ?#, n, [n], m), do: {1, m}
  defp arr([], ?#, _n, _ns, m), do: {0, m}
  defp arr([], ?., 0, [], m), do: {1, m}
  defp arr([], ?., 0, _ns, m), do: {0, m}

  defp arr([?# | _group], _p, _n, [], m), do: {0, m}
  defp arr([?# | group], ?., _n, ns, m), do: arr(group, ?#, 1, ns, m)
  defp arr([?# | group], ?#, n, ns, m), do: arr(group, ?#, n + 1, ns, m)

  defp arr([?. | group], ?., _n, ns, m), do: arr(group, ?., 0, ns, m)
  defp arr([?. | group], ?#, n, [n | ns], m), do: arr(group, ?., 0, ns, m)
  defp arr([?. | _group], ?#, _n, _ns, m), do: {0, m}

  defp arr([?? | group], ?#, n, [n | ns], m), do: arr(group, ?., 0, ns, m)
  defp arr([?? | group], ?#, n, ns, m), do: arr(group, ?#, n + 1, ns, m)

  defp arr([?? | group], ?., 0, ns, m) do
    cached = m[{group, ns}]

    if cached do
      {cached, m}
    else
      {a, m} = arr(group, ?#, 1, ns, m)
      {b, m} = arr(group, ?., 0, ns, m)

      c = a + b
      m = Map.put(m, {group, ns}, c)

      {c, m}
    end
  end

  defp arr({group, ns}) do
    arr(group, ?., 0, ns, %{})
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [group, ns] = String.split(line, " ")
    ns = ns |> String.split(",") |> Enum.map(&String.to_integer/1)
    group = group |> to_charlist()
    {group, ns}
  end
end
