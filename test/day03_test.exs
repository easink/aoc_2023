defmodule AoCDay03Test do
  use ExUnit.Case

  test "part1" do
    assert AoC.Day03.part1("inputs/day03.sample") == 4361
    assert AoC.Day03.part1("inputs/day03") == 528819
  end

  test "part2" do
    assert AoC.Day03.part2("inputs/day03.sample") == 467835
    assert AoC.Day03.part2("inputs/day03") == 80403602
  end
end
