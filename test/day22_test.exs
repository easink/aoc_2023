defmodule AoCDay22Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day22.part1("inputs/day22.sample") == 5
    assert AoC.Day22.part1("inputs/day22") == 480
  end

  test "part2" do
    assert AoC.Day22.part2("inputs/day22.sample") == 7
    assert AoC.Day22.part2("inputs/day22") == 84021
  end
end
