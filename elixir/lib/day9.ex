defmodule Day9 do
  @preamble 25
  @wrong_num 69_316_178

  @input File.read!("inputs/day9")
         |> String.split("\n", trim: true)
         |> Enum.map(&String.to_integer/1)

  # @preamble 5
  # @wrong_num 127

  # @input File.read!("inputs/day9_sample")
  #        |> String.split("\n", trim: true)
  #        |> Enum.map(&String.to_integer/1)

  def p1(), do: @input |> find_worng_num()

  def find_worng_num(l) do
    {preamble, rest} = Enum.split(l, @preamble)
    sums = for x <- preamble, y <- preamble, do: x + y

    if Enum.member?(sums, hd(rest)) do
      find_worng_num(tl(l))
    else
      hd(rest)
    end
  end

  def p2(), do: @input |> Enum.take_while(&(&1 != @wrong_num)) |> running_sum(0, 0, [])

  def running_sum([h | t], sum, from_idx, acc) do
    new_sum = h + sum
    new_acc = [h | acc]

    if new_sum == @wrong_num do
      Enum.min(new_acc) + Enum.max(new_acc)
    else
      if new_sum < @wrong_num do
        running_sum(t, new_sum, from_idx, new_acc)
      else
        # next attempt
        new_idx = from_idx + 1
        {_, next_list} = Enum.split(@input, new_idx)
        running_sum(next_list, 0, new_idx, [])
      end
    end
  end
end

# Day9.p1() |> IO.inspect(label: "part 1")
# 69316178

# Day9.p2() |> IO.inspect(label: "part 2")
# 9351526
