defmodule AoCDay23Test do
  use ExUnit.Case

  @moduletag timeout: :infinity

  # 130s
  test "part1" do
    assert AoC.Day23.part1("inputs/day23.sample") == 94
    assert AoC.Day23.part1("inputs/day23") == 2438
  end

  # 160s
  test "part2" do
    assert AoC.Day23.part2("inputs/day23.sample") == 154
    assert AoC.Day23.part2("inputs/day23") == 6658
  end
end
