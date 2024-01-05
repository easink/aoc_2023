defmodule AoCDay21Test do
  use ExUnit.Case

  # @moduletag timeout: :infinity
  test "part1" do
    assert AoC.Day21.part1("inputs/day21.sample", 6) == 16
    assert AoC.Day21.part1("inputs/day21", 64) == 3574
  end

  test "part2" do
    assert AoC.Day21.part1("inputs/day21.sample2", 10) == 50
    assert AoC.Day21.part1("inputs/day21.sample2", 50) == 1594
    assert AoC.Day21.part1("inputs/day21.sample2", 100) == 6536
    # assert AoC.Day21.part1("inputs/day21.sample2", 500) == 167004
    # assert AoC.Day21.part1("inputs/day21.sample2", 1000) == 668697
    # assert AoC.Day21.part1("inputs/day21.sample2", 5000) == 16733044

    assert AoC.Day21.part2() == 600090522932119
  end
end
