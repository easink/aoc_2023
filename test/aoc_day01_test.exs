defmodule AoCDay01Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day01.part1("inputs/day01.sample") == 142
    assert AoC.Day01.part1("inputs/day01") == 54561
  end

  test "part2" do
    assert AoC.Day01.part2("inputs/day01.part2.sample") == 281
    assert AoC.Day01.part2("inputs/day01") == 213_958
  end
end
