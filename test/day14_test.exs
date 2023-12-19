defmodule AoCDay14Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day14.part1("inputs/day14.sample") == 136
    assert AoC.Day14.part1("inputs/day14") == 109833
  end

  test "part2" do
    assert AoC.Day14.part2("inputs/day14.sample") == 64
    assert AoC.Day14.part2("inputs/day14") == 99875
  end
end
