defmodule AoC.Day24 do
  @moduledoc """
  Solved part 2 with Gauss Jordan Elimination
  """

  def part1(filename, xy_range) do
    filename
    |> parse()
    |> find_intersections_2d(xy_range, 0)
  end

  def part2(filename) do
    filename
    |> parse()
    |> calc_rock()
    |> Enum.sum()
  end

  defp calc_rock(hailstones) do
    [h0, h1, h2, h3, h4] = Enum.take(hailstones, 5)

    [x, y] =
      [
        equations_xy(h0, h1),
        equations_xy(h1, h2),
        equations_xy(h2, h3),
        equations_xy(h3, h4)
      ]
      |> gauss_jordan_elimination()
      |> Enum.take(2)
      |> Enum.map(&(Enum.at(&1, 4) |> round()))

    [_x, z] =
      [
        equations_xz(h0, h1),
        equations_xz(h1, h2),
        equations_xz(h2, h3),
        equations_xz(h3, h4)
      ]
      |> gauss_jordan_elimination()
      |> Enum.take(2)
      |> Enum.map(&(Enum.at(&1, 4) |> round()))

    [x, y, z]
  end

  defp equations_xy(h0, h1) do
    {{x0, y0, _z0}, {vx0, vy0, _vz0}} = h0
    {{x1, y1, _z1}, {vx1, vy1, _vz1}} = h1
    #    X          Y         VX       VY       =
    [vy1 - vy0, vx0 - vx1, y0 - y1, x1 - x0, y0 * vx0 - x0 * vy0 - y1 * vx1 + x1 * vy1]
  end

  defp equations_xz(h0, h1) do
    {{x0, _y0, z0}, {vx0, _vy0, vz0}} = h0
    {{x1, _y1, z1}, {vx1, _vy1, vz1}} = h1
    #    X          Z         VX       VZ       =
    [vz1 - vz0, vx0 - vx1, z0 - z1, x1 - x0, z0 * vx0 - x0 * vz0 - z1 * vx1 + x1 * vz1]
  end

  defp gauss_jordan_elimination(matrix),
    do: gauss_jordan_elimination(matrix, [], 0)

  defp gauss_jordan_elimination([], new, _i), do: Enum.reverse(new)

  defp gauss_jordan_elimination(rest, new, i) do
    {pivot, m} = find_pivot(rest, i)
    pivot = normalize_row_by_i(pivot, i)
    rest = normalize_rows_by_i(m, pivot, i)
    new = normalize_rows_by_i(new, pivot, i)

    gauss_jordan_elimination(rest, [pivot | new], i + 1)
  end

  defp find_pivot(matrix, acc \\ [], i)
  defp find_pivot([], _m_acc, _i), do: raise("Could not find pivot!")

  defp find_pivot([row | m], m_acc, i) do
    case value_at(row, i) do
      0.0 -> find_pivot(m, [row | m_acc], i)
      _value -> {row, m ++ m_acc}
    end
  end

  defp value_at(row, i) do
    val = Enum.at(row, i)
    if is_integer(val), do: val + 0.0, else: val
  end

  defp normalize_row_by_i(row, i) do
    value = Enum.at(row, i)
    Enum.map(row, fn val -> val / value end)
  end

  defp normalize_rows_by_i(rows, pivot, i) do
    pvalue = Enum.at(pivot, i)

    Enum.map(rows, fn row ->
      value = Enum.at(row, i)
      value = value / pvalue
      sub_row_by_value(row, pivot, value)
    end)
  end

  defp sub_row_by_value(row1, row2, value),
    do: Enum.zip_with(row1, row2, fn a, b -> a - b * value end)

  defp find_intersections_2d([], _xy_range, n), do: n

  defp find_intersections_2d([vector | vectors], xy_range, n) do
    m =
      Enum.count(vectors, fn v ->
        case intersection_2d(vector, v) do
          :parallel ->
            false

          point ->
            in_area(point, xy_range) and
              in_front(point, vector) and
              in_front(point, v)
        end
      end)

    find_intersections_2d(vectors, xy_range, n + m)
  end

  defp intersection_2d(vec1, vec2) do
    {{x1, y1, _z1}, {dx1, dy1, _dz1}} = vec1
    x2 = x1 + dx1
    y2 = y1 + dy1
    {{x3, y3, _z3}, {dx3, dy3, _dz3}} = vec2
    x4 = x3 + dx3
    y4 = y3 + dy3

    denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

    if denom == 0 do
      :parallel
    else
      numer1 = x1 * y2 - y1 * x2
      numer2 = x3 * y4 - y3 * x4

      px = (numer1 * (x3 - x4) - numer2 * (x1 - x2)) / denom
      py = (numer1 * (y3 - y4) - numer2 * (y1 - y2)) / denom

      {px, py}
    end
  end

  defp in_area({x, y}, {a, b}), do: a <= x and x <= b and a <= y and y <= b

  defp in_front(pos, vector) do
    {x, y} = pos
    {{xv, yv, _zv}, {dxv, dyv, _dzv}} = vector
    (x - xv) * dxv + (y - yv) * dyv > 0.0
  end

  defp parse(filename) do
    filename
    |> File.read!()
    |> String.split([" ", "@", ",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(3)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end
end
