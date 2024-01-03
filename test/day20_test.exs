defmodule AoCDay20Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day20.part1("inputs/day20.sample1") == 32000000
    assert AoC.Day20.part1("inputs/day20.sample2") == 11687500
    assert AoC.Day20.part1("inputs/day20") == 879834312
  end

  test "part2" do
    assert AoC.Day20.part2("inputs/day20") == 243037165713371
  end
end
