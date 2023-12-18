defmodule AoCDay13Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day13.part1("inputs/day13.sample") == 405
    assert AoC.Day13.part1("inputs/day13") == 39939
  end

  test "part2" do
    assert AoC.Day13.part2("inputs/day13.sample") == 400
    assert AoC.Day13.part2("inputs/day13") == 32069
  end
end
