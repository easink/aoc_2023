defmodule AoC.Day21 do
  @moduledoc """

  317 - 186 = 131 (cycle)
  317 + 131 = 448 (2 cycle)

  > factor 26501300 (-65 [index])
  26501300: 2 2 5 5 7 17 17 131

  65 + 131 * 0 = 65

  3719

  65 + 131 * 1 = 196

           1
     1 19337  6455
        6459   937

  65 + 131 * 2
  327

                 1
              6581   962
     1  6571 28234 13727  6455
         976 13717  6429   937
              6459   937

  65 + 131 * 3
  458

                       1
                    6581   962
              1011 13767  6466   962
     1  6571 13767 29065 14597 13727  6455
         976  6456 14597  7327  6429   937
               976 13717  6429   937
                    6459   937



  65 + 131 * 4 = 589

                             1
                          6581   962
                    1011 13767  6466   962
              1011  6506 14598  7326  6466   962
     1  6571 13767 14598 29064 14598 14597 13727  6455
         976  6456  7326 14598  7336  7327  6429   937
               976  6456 14597  7327  6429   937
                     976 13717  6429   937
                          6459   937


  65 + 131 * 5 = 720
  65 + 131 * 6 = 851
  65 + 131 * 7 = 982
  65 + 131 * 8 = 1113

                                                     1
                                                  6581   962
                                            1011 13767  6466   962
                                      1011  6506 14598  7326  6466   962
                                1011  6506  7327 14597  7337  7326  6466   962
                          1011  6506  7327  7336 14598  7326  7337  7326  6466   962
                    1011  6506  7327  7336  7327 14597  7337  7326  7337  7326  6466   962
              1011  6506  7327  7336  7327  7336 14598  7326  7337  7326  7337  7326  6466   962
     1  6571 13767 14598 14597 14598 14597 14598 29064 14598 14597 14598 14597 14598 14597 13727  6455
         976  6456  7326  7337  7326  7337  7326 14598  7336  7327  7336  7327  7336  7327  6429   937
               976  6456  7326  7337  7326  7337 14597  7327  7336  7327  7336  7327  6429   937
                     976  6456  7326  7337  7326 14598  7336  7327  7336  7327  6429   937
                           976  6456  7326  7337 14597  7327  7336  7327  6429   937
                                 976  6456  7326 14598  7336  7327  6429   937
                                       976  6456 14597  7327  6429   937
                                             976 13717  6429   937
                                                  6459   937


  """

  @north {0, -1}
  @south {0, 1}
  @west {-1, 0}
  @east {1, 0}

  def part1(filename, steps) do
    filename
    |> parse()
    |> step(steps)
    |> Enum.count()
  end

  @doc """
  1113:

                                                     1
                                                  6581   962
                                            1011 13767  6466   962
                                      1011  6506 14598  7326  6466   962
                                1011  6506  7327 14597  7337  7326  6466   962
                          1011  6506  7327  7336 14598  7326  7337  7326  6466   962
                    1011  6506  7327  7336  7327 14597  7337  7326  7337  7326  6466   962
              1011  6506  7327  7336  7327  7336 14598  7326  7337  7326  7337  7326  6466   962
     1  6571 13767 14598 14597 14598 14597 14598 29064 14598 14597 14598 14597 14598 14597 13727  6455
         976  6456  7326  7337  7326  7337  7326 14598  7336  7327  7336  7327  7336  7327  6429   937
               976  6456  7326  7337  7326  7337 14597  7327  7336  7327  7336  7327  6429   937
                     976  6456  7326  7337  7326 14598  7336  7327  7336  7327  6429   937
                           976  6456  7326  7337 14597  7327  7336  7327  6429   937
                                 976  6456  7326 14598  7336  7327  6429   937
                                       976  6456 14597  7327  6429   937
                                             976 13717  6429   937
                                                  6459   937
  """
  def part2() do
    # n = 202300
    n = div(26_501_365 - 65, 131)

    # border
    nw_border = (n - 2) * 1011 + (n - 3) * 6506
    ne_border = (n - 1) * 962 + (n - 2) * 6466
    sw_border = (n - 1) * 976 + (n - 2) * 6456
    se_border = (n - 0) * 937 + (n - 1) * 6429
    border = nw_border + ne_border + sw_border + se_border

    # cross
    w_cross = 1 + 6571 + 13767 + calc_cycle({14598, 14597}, n - 3)
    n_cross = 1 + 6581 + 13767 + calc_cycle({14598, 14597}, n - 3)
    e_cross = 0 + 6455 + 13727 + calc_cycle({14597, 14598}, n - 2)
    s_cross = 0 + 6459 + 13717 + calc_cycle({14597, 14598}, n - 2)
    cross = w_cross + n_cross + e_cross + s_cross

    # tri
    nw_tri = calc_tri({7327, 7336}, n - 4)
    ne_tri = calc_tri({7326, 7337}, n - 3)
    sw_tri = calc_tri({7326, 7337}, n - 3)
    se_tri = calc_tri({7327, 7336}, n - 2)
    tri = nw_tri + ne_tri + sw_tri + se_tri

    # center (flux between 29064 and 29065, but 29064 on even)
    center = 29064

    # total
    center + cross + tri + border
  end

  def print_part2(filename) do
    filename
    |> parse()
    |> print_steps(1)
  end

  defp calc_cycle({a, b}, n), do: calc_cycle(a, n) + calc_cycle(b, n - 1)
  defp calc_cycle(x, n), do: x * div(n + 1, 2)

  defp calc_tri({a, b}, n), do: calc_tri(a, n) + calc_tri(b, n - 1)
  defp calc_tri(x, n), do: x * div((n + 1) * (n + 1), 4)

  defp print_steps({gardners, rocks, size}, steps) do
    print_steps(gardners, rocks, size, steps)
  end

  defp print_steps(gardners, rocks, size, steps) do
    gardners
    |> Enum.reduce(MapSet.new(), fn pos, acc ->
      pos
      |> add_neighbours(rocks, size)
      |> MapSet.new()
      |> MapSet.union(acc)
    end)
    |> tap(fn g ->
      if rem(steps - 65, 131) == 0 do
        # IO.puts(IO.ANSI.clear())
        # IO.puts(IO.ANSI.cursor(0, 0))
        dbg(steps)
        boards_calc(g, size)
      end
    end)
    |> print_steps(rocks, size, steps + 1)
  end

  defp coord_to_board({x, y}, {width, height}) do
    {div(x, width), div(y, height)}
  end

  defp boards_calc(coords, size) do
    coords
    |> Enum.reduce(%{}, fn coord, acc ->
      board = coord_to_board(coord, size)
      Map.update(acc, board, 1, &(&1 + 1))
    end)
    |> print_board()
  end

  defp print_board(coords_calc) do
    {{min_x, max_x}, {min_y, max_y}} = max_coord(Map.keys(coords_calc))

    for y <- min_y..max_y do
      IO.puts("")

      for x <- min_x..max_x do
        case Map.get(coords_calc, {x, y}) do
          nil -> IO.write("      ")
          val -> Integer.to_string(val) |> String.pad_leading(6) |> IO.write()
        end
      end
    end

    IO.puts("")
    coords_calc
  end

  defp step({gardners, rocks, size}, steps) do
    step(gardners, rocks, size, steps)
  end

  defp step(gardners, _rocks, _size, 0), do: gardners

  defp step(gardners, rocks, size, steps) do
    gardners
    |> Enum.reduce(MapSet.new(), fn pos, acc ->
      pos
      |> add_neighbours(rocks, size)
      |> MapSet.new()
      |> MapSet.union(acc)
    end)
    # |> print(rocks, size)
    |> step(rocks, size, steps - 1)
  end

  defp vertex_add({x, y}, {dx, dy}), do: {x + dx, y + dy}

  defp add_neighbours(coord, rocks, size) do
    [@north, @south, @west, @east]
    |> Enum.map(&vertex_add(coord, &1))
    |> Enum.reject(fn coord -> coord_to_board_coord(coord, size) in rocks end)
  end

  defp parse(filename) do
    filename
    |> File.read!()
    |> String.split()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {x_line, y_index}, acc ->
      x_line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {val, x_index}, acc ->
        Map.put(acc, {x_index, y_index}, val)
      end)
    end)
    |> then(fn coords ->
      {start, _} = Enum.find(coords, fn {_coord, val} -> val == "S" end)
      gardners = MapSet.new([start])

      rocks =
        coords
        |> Map.filter(fn {_coord, val} -> val == "#" end)
        |> Map.keys()

      {{_mix_x, max_x}, {_min_y, max_y}} = coords |> Map.keys() |> max_coord()
      {width, height} = {max_x + 1, max_y + 1}

      {
        gardners,
        rocks,
        {width, height}
      }
    end)
  end

  defp max_coord(coords) do
    coords
    |> Enum.reduce({{0, 0}, {0, 0}}, fn {x, y}, {{min_x, max_x}, {min_y, max_y}} ->
      {{min(x, min_x), max(x, max_x)}, {min(y, min_y), max(y, max_y)}}
    end)
  end

  defp coord_to_board_coord({x, y}, {width, height}) do
    xn = rem(rem(x, width) + width, width)
    yn = rem(rem(y, height) + height, height)
    {xn, yn}
  end

  # defp print(gardeners, rocks, {width, height} = size) do
  #   {{min_x, max_x}, {min_y, max_y}} = max_coord(gardeners)

  #   from_x = div(min_x - width + 1, width) * width
  #   to_x = div(max_x + width - 1, width) * width
  #   from_y = div(min_y - height + 1, height) * height
  #   to_y = div(max_y + height - 1, height) * height

  #   for y <- from_y..to_y do
  #     IO.puts("")

  #     for x <- from_x..to_x do
  #       board_coord = coord_to_board_coord({x, y}, size)

  #       cond do
  #         {x, y} in gardeners -> IO.write("O")
  #         board_coord in rocks -> IO.write("#")
  #         true -> IO.write(".")
  #       end
  #     end
  #   end

  #   IO.puts("")
  #   gardeners
  # end
end
