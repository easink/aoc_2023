defmodule AoCDay05Test do
  use ExUnit.Case
  @moduletag timeout: :infinity

  test "part1" do
    assert AoC.Day05.part1("inputs/day05.sample") == 35
    assert AoC.Day05.part1("inputs/day05") == 551761867
  end

  test "part2" do
    assert AoC.Day05.part2("inputs/day05.sample") == 46
    assert AoC.Day05.part2("inputs/day05") == 57451709
  end
end
