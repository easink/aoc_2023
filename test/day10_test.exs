defmodule AoCDay10Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day10.part1("inputs/day10.sample1") == 4
    assert AoC.Day10.part1("inputs/day10.sample2") == 8
    assert AoC.Day10.part1("inputs/day10") == 6951
  end

  test "part2" do
    assert AoC.Day10.part2("inputs/day10.sample1") == 1
    assert AoC.Day10.part2("inputs/day10.sample3") == 4
    assert AoC.Day10.part2("inputs/day10.sample4") == 8
    assert AoC.Day10.part2("inputs/day10.sample5") == 10
    assert AoC.Day10.part2("inputs/day10") == 563
  end
end
