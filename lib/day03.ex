defmodule AoC.Day03 do
  @moduledoc false

  def part1(filename) do
    {numbers, symbols} = parse(filename)

    symbol_positions = Map.keys(symbols)

    numbers
    |> Map.filter(fn {box, _num} ->
      Enum.any?(symbol_positions, fn sym_pos ->
        in_box?(box, sym_pos)
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(filename) do
    {numbers, symbols} = parse(filename)

    symbol_positions =
      symbols
      |> Map.filter(fn {_pos, sym} -> sym == ?* end)
      |> Map.keys()

    symbol_positions
    |> Enum.map(fn sym_pos ->
      Map.filter(numbers, fn {box, _num} -> in_box?(box, sym_pos) end)
    end)
    |> Enum.filter(fn nums -> map_size(nums) == 2 end)
    |> Enum.map(fn nums -> nums |> Map.values() |> Enum.product() end)
    |> Enum.sum()
  end

  defp parse(filename) do
    filename
    |> File.read!()
    |> parse_engine()
  end

  defp parse_engine(engine) do
    engine
    |> String.to_charlist()
    |> parse_engine({0, 0}, %{}, %{})
  end

  defp parse_engine([], _pos, numbers, symbols), do: {numbers, symbols}

  defp parse_engine([?. | engine], {x, y}, numbers, symbols) do
    parse_engine(engine, {x + 1, y}, numbers, symbols)
  end

  defp parse_engine([?\n | engine], {_x, y}, numbers, symbols) do
    parse_engine(engine, {0, y + 1}, numbers, symbols)
  end

  defp parse_engine([n | engine], {x, y}, numbers, symbols) when n in ?0..?9 do
    {num, len, engine} = parse_number([n | engine], 0, 0)
    box = {{x - 1, y - 1}, {x + len, y + 1}}
    numbers = Map.put(numbers, box, num)
    parse_engine(engine, {x + len, y}, numbers, symbols)
  end

  defp parse_engine([n | engine], {x, y}, numbers, symbols) do
    symbols = Map.put(symbols, {x, y}, n)
    parse_engine(engine, {x + 1, y}, numbers, symbols)
  end

  defp parse_number([n | engine], num, len) when n in ?0..?9 do
    parse_number(engine, num * 10 + (n - ?0), len + 1)
  end

  defp parse_number([n | engine], num, len) do
    {num, len, [n | engine]}
  end

  defp in_box?(box, pos) do
    {{x1, y1}, {x2, y2}} = box
    {x, y} = pos

    x in x1..x2 and y in y1..y2
  end
end
