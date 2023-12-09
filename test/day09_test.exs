defmodule AoCDay09Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day09.part1("inputs/day09.sample") == 114
    assert AoC.Day09.part1("inputs/day09") == 1853145119
  end

  test "part2" do
    assert AoC.Day09.part2("inputs/day09.sample") == 2
    assert AoC.Day09.part2("inputs/day09") == 923
  end
end
