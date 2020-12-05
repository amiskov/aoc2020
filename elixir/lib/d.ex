defmodule D do
  def input() do
    File.read!("inputs/day5")
    # File.read!("inputs/day5_sample")
  end

  @doc "What is the highest seat ID on a boarding pass?"
  def p1 do
    # BFFFBBFRRR: row 70, column 7, seat ID 567.
    # FFFBBBFRRR: row 14, column 7, seat ID 119.
    # BBFFBBFRLL: row 102, column 4, seat ID 820.
    input()
  end

  def p2 do
    input()
  end
end

D.p1()
|> IO.inspect(label: "test")

D.p2()
|> IO.inspect()
