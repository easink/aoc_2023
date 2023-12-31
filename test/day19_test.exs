defmodule AoCDay19Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day19.part1("inputs/day19.sample") == 19114
    assert AoC.Day19.part1("inputs/day19") == 330820
  end

  test "part2" do
    assert AoC.Day19.part2("inputs/day19.simple") == 147513840000000
    assert AoC.Day19.part2("inputs/day19.sample") == 167409079868000
    assert AoC.Day19.part2("inputs/day19") == 123972546935551
  end
end
