defmodule AoCDay08Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day08.part1("inputs/day08.sample1") == 2
    assert AoC.Day08.part1("inputs/day08.sample2") == 6
    assert AoC.Day08.part1("inputs/day08") == 12361
  end

  test "part2" do
    assert AoC.Day08.part2("inputs/day08.sample3") == 6
    assert AoC.Day08.part2("inputs/day08") == 18215611419223
  end
end
