defmodule Day1 do
  def input() do
    File.read!("inputs/day1_sample")

    File.read!("inputs/day1")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def prepare_vals(vals) do
    for a <- vals, b <- vals, c <- vals do
      [a, b, c]
      |> Enum.uniq()
    end
  end

  def res(inp) do
    vals =
      prepare_vals(inp)
      |> Enum.filter(fn l -> Enum.count(l) == 3 end)

    Enum.filter(vals, fn [a, b, c] -> a + b + c == 2020 end)
    |> IO.inspect()
    |> Enum.map(fn [a, b, c] -> a * b * c end)
  end

  def run() do
    res(input())
  end
end

Day1.run() |> IO.inspect()
