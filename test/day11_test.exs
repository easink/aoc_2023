defmodule AoCDay10Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day11.part("inputs/day11.sample", 2) == 374
    assert AoC.Day11.part("inputs/day11", 2) == 10292708
  end

  test "part2" do
    assert AoC.Day11.part("inputs/day11.sample", 10) == 1030
    assert AoC.Day11.part("inputs/day11.sample", 100) == 8410
    assert AoC.Day11.part("inputs/day11", 1000000) == 790194712336
  end
end
