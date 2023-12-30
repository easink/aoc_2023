defmodule AoCDay18Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day18.part1("inputs/day18.sample") == 62
    assert AoC.Day18.part1("inputs/day18") == 76387
  end

  test "part2" do
    assert AoC.Day18.part2("inputs/day18.sample") == 952408144115
    assert AoC.Day18.part2("inputs/day18") == 250022188522074
  end
end
