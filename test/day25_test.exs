defmodule AoCDay25Test do
  use ExUnit.Case

  @moduletag timeout: :infinity

  test "part1" do
    assert AoC.Day25.part1("inputs/day25.sample") == 54
    assert AoC.Day25.part1("inputs/day25") == 543036
  end

  test "part2" do
    assert true
  end
end
