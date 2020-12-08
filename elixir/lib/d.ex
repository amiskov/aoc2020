defmodule D do
  def input() do
    # File.read!("inputs/day8")
    # File.read!("inputs/day8_sample")
    File.read!("inputs/day8_sample_correct")
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      [op, val] = String.split(l, "\s")
      {String.to_atom(op), String.to_integer(val)}
    end)
  end

  def run_until_idx_repeats(
        program,
        %{index: index, accumulator: accumulator} = memory,
        used_indexes
      ) do
    if index == Enum.count(program) do
      # program correctly terminated
      {memory, true}
    else
      if Enum.member?(used_indexes, index) do
        # program incorrectly terminated
        {memory, false}
      else
        case Enum.at(program, index) do
          {:nop, _val} ->
            new_index = index + 1

            run_until_idx_repeats(
              program,
              %{index: new_index, accumulator: accumulator},
              used_indexes ++ [index]
            )

          {:acc, val} ->
            new_index = index + 1

            run_until_idx_repeats(
              program,
              %{index: new_index, accumulator: accumulator + val},
              used_indexes ++ [index]
            )

          {:jmp, val} ->
            # may be :nop
            new_index = index + val

            run_until_idx_repeats(
              program,
              %{index: new_index, accumulator: accumulator},
              used_indexes ++ [index]
            )

          nil ->
            :error
        end
      end
    end
  end

  def p1() do
    input()
    |> run_until_idx_repeats(%{index: 0, accumulator: 0}, [])
  end

  def p2() do
    input()
  end
end

D.p1() |> IO.inspect(label: "part 1 is correct")
# %{accumulator: 1489, index: 163}

# D.p2() |> IO.inspect(label: "part 2")
