defmodule Day3 do
  @doc """
  TODO: repeat the pattern in lines lazily
  """
  def input() do
    File.read!("inputs/day3")
    # File.read!("inputs/day3_sample")
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(&multiply_line/1)
  end

  def count_trees(slope_fn) do
    input()
    |> Enum.map(slope_fn)
    |> Enum.filter(&(&1 == "#"))
    |> Enum.count()
  end

  # Make sure the line is long enough
  def multiply_line({trees, index}), do: {String.duplicate(trees, index + 1), index}

  def at(shift_right), do: fn {t, i} -> String.at(t, i * shift_right) end
  # Same body with trickier sintax:
  # &String.at(elem(&1, 0), elem(&1, 1) * shift_right)

  # Right 1, down 2.
  def get_at_position12({trees, index}) do
    if rem(index, 2) == 0 do
      right = div(index, 2)

      String.at(trees, right)
    else
      nil
    end
  end

  def part1, do: count_trees(at(3))

  def part2() do
    [at(1), at(3), at(5), at(7), &get_at_position12/1]
    |> Enum.reduce(1, fn f, acc -> acc * count_trees(f) end)
  end
end

# Day3.part1() |> IO.inspect()
# Day3.part2() |> IO.inspect()
