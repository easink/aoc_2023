defmodule AoCDay02Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day02.part1("inputs/day02.sample") == 8
    assert AoC.Day02.part1("inputs/day02") == 2545
  end

  test "part2" do
    assert AoC.Day02.part2("inputs/day02.sample") == 2286
    assert AoC.Day02.part2("inputs/day02") == 78111
  end
end
