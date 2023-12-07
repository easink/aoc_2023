defmodule AoCDay07Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day07.part1("inputs/day07.sample") == 6440
    assert AoC.Day07.part1("inputs/day07") == 248559379
  end

  test "part2" do
    assert AoC.Day07.part2("inputs/day07.sample") == 5905
    assert AoC.Day07.part2("inputs/day07") == 249631254
  end
end
