defmodule AoCDay16Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day16.part1("inputs/day16.sample") == 46
    assert AoC.Day16.part1("inputs/day16") == 7392
  end

  test "part2" do
    assert AoC.Day16.part2("inputs/day16.sample") == 51
    assert AoC.Day16.part2("inputs/day16") == 7665
  end
end
