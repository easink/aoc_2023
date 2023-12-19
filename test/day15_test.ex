defmodule AoCDay15Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day15.part1("inputs/day15.sample") == 1320
    assert AoC.Day15.part1("inputs/day15") == 510_013
  end

  test "part2" do
    assert AoC.Day15.part2("inputs/day15.sample") == 145
    assert AoC.Day15.part2("inputs/day15") == 268_497
  end
end
