defmodule AoCDay12Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day12.part1("inputs/day12.sample") == 21
    assert AoC.Day12.part1("inputs/day12") == 6958
  end

  test "part2" do
    assert AoC.Day12.part2("inputs/day12.sample") == 525152
    assert AoC.Day12.part2("inputs/day12") == 6555315065024
  end
end
