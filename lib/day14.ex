defmodule AoC.Day14 do
  @moduledoc false

  def part1(filename) do
    {o_acc, hup, _hleft} =
      filename
      |> parse()
      |> ranges()

    o_acc
    |> tilt_up(hup)
    |> Enum.map(fn {y, _x} -> y end)
    |> Enum.sum()
  end

  def part2(filename) do
    {o_acc, hup, hleft} =
      filename
      |> parse()
      |> ranges()

    # after 142 cycles it loops every 28 cycles
    # 35714285 * 28 + 20 = 1000000000
    1..(20 + 28 * 5)
    |> Enum.reduce(o_acc, fn _i, acc -> cycle(acc, hup, hleft) end)
    |> Enum.map(fn {y, _x} -> y end)
    |> Enum.sum()
  end

  defp cycle(o_acc, hup, hleft) do
    o_acc
    |> tilt_up(hup)
    |> tilt_left(hleft)
    |> tilt_down(hup)
    |> tilt_right(hleft)
  end

  defp tilt_up(o_acc, hup) do
    hup
    |> Enum.with_index(1)
    |> Enum.map(fn {ranges, x_pos} ->
      ranges
      |> Enum.map(fn {a, b} ->
        m = Enum.filter(o_acc, fn {y, x} -> x == x_pos and y in a..b end)

        if m == [] do
          []
        else
          for y <- (b - length(m) + 1)..b, do: {y, x_pos}
        end
      end)
      |> List.flatten()
    end)
    |> List.flatten()
  end

  defp tilt_down(o_acc, hup) do
    hup
    |> Enum.with_index(1)
    |> Enum.map(fn {ranges, x_pos} ->
      ranges
      |> Enum.map(fn {b, a} ->
        m = Enum.filter(o_acc, fn {y, x} -> x == x_pos and y in a..b end)

        if m == [] do
          []
        else
          for y <- (b + length(m) - 1)..b, do: {y, x_pos}
        end
      end)
      |> List.flatten()
    end)
    |> List.flatten()
  end

  defp tilt_right(o_acc, hleft) do
    hleft
    |> Enum.with_index(1)
    |> Enum.map(fn {ranges, y_pos} ->
      ranges
      |> Enum.map(fn {a, b} ->
        m = Enum.filter(o_acc, fn {y, x} -> y == y_pos and x in a..b end)

        if m == [] do
          []
        else
          for x <- (b - length(m) + 1)..b, do: {y_pos, x}
        end
      end)
      |> List.flatten()
    end)
    |> List.flatten()
  end

  defp tilt_left(o_acc, hleft) do
    hleft
    |> Enum.with_index(1)
    |> Enum.map(fn {ranges, y_pos} ->
      ranges
      |> Enum.map(fn {b, a} ->
        m = Enum.filter(o_acc, fn {y, x} -> y == y_pos and x in a..b end)

        if m == [] do
          []
        else
          for x <- (b + length(m) - 1)..b, do: {y_pos, x}
        end
      end)
      |> List.flatten()
    end)
    |> List.flatten()
  end

  defp ranges({o_acc, h_acc, max_y, max_x}) do
    hy_up_ranges = y_ranges(h_acc, max_y, max_x)
    hx_left_ranges = x_ranges(h_acc, max_y, max_x)
    {o_acc, hy_up_ranges, hx_left_ranges}
  end

  defp y_ranges(h_acc, max_y, max_x) do
    for x <- 1..max_x do
      h_acc
      |> Enum.filter(fn {_h_y, h_x} -> h_x == x end)
      |> Enum.map(fn {h_y, _h_x} -> h_y end)
      |> invert_list(max_y)
    end
  end

  defp x_ranges(h_acc, max_y, max_x) do
    for y <- 1..max_y do
      h_acc
      |> Enum.filter(fn {h_y, _h_x} -> h_y == y end)
      |> Enum.map(fn {_h_y, h_x} -> h_x end)
      |> invert_list(max_x)
    end
  end

  defp invert_list(list, max) do
    (Range.to_list(1..max) -- Enum.sort(list))
    |> by_ranges()
  end

  defp by_ranges([], start, last, res) do
    Enum.reverse([{start, last} | res])
  end

  defp by_ranges([a | list], start, last, res) do
    if a == last + 1 do
      by_ranges(list, start, a, res)
    else
      by_ranges(list, a, a, [{start, last} | res])
    end
  end

  defp by_ranges([]), do: []

  defp by_ranges([a | list]) do
    by_ranges(list, a, a, [])
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce({[], [], 0, 0}, fn {line, y}, {o_acc, h_acc, _max_y, _max_x} ->
      line
      |> String.to_charlist()
      |> Enum.with_index(1)
      |> Enum.reduce({o_acc, h_acc, y, 0}, fn
        {?., x}, {o_acc, h_acc, y, max_x} -> {o_acc, h_acc, y, max(max_x, x)}
        {?O, x}, {o_acc, h_acc, y, max_x} -> {[{y, x} | o_acc], h_acc, y, max(max_x, x)}
        {?#, x}, {o_acc, h_acc, y, max_x} -> {o_acc, [{y, x} | h_acc], y, max(max_x, x)}
      end)
    end)
  end
end
