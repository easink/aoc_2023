defmodule AoCDay06Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day06.part1("inputs/day06.sample") == 288
    assert AoC.Day06.part1("inputs/day06") == 2344708
  end

  test "part2" do
    assert AoC.Day06.part2("inputs/day06.sample") == 71503
    assert AoC.Day06.part2("inputs/day06") == 30125202
  end
end
