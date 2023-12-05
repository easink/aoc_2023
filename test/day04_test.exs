defmodule AoCDay04Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day04.part1("inputs/day04.sample") == 13
    assert AoC.Day04.part1("inputs/day04") == 20407
  end

  test "part2" do
    assert AoC.Day04.part2("inputs/day04.sample") == 30
    assert AoC.Day04.part2("inputs/day04") == 23806951
  end
end
