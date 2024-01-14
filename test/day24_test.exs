defmodule AoCDay24Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day24.part1("inputs/day24.sample", {7, 27}) == 2
    assert AoC.Day24.part1("inputs/day24", {200000000000000, 400000000000000}) == 24192
  end

  test "part2" do
    assert AoC.Day24.part2("inputs/day24.sample") == 47
    assert AoC.Day24.part2("inputs/day24") == 664822352550558
  end
end
