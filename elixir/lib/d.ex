defmodule D do
  def input() do
    File.read!("inputs/day8")
    # File.read!("inputs/day8_sample")
    # File.read!("inputs/day8_sample_correct")
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
        # run the next operator
        case Enum.at(program, index) do
          {:nop, _val} ->
            run_until_idx_repeats(
              program,
              %{index: index + 1, accumulator: accumulator},
              [index | used_indexes]
            )

          {:acc, val} ->
            run_until_idx_repeats(
              program,
              %{index: index + 1, accumulator: accumulator + val},
              [index | used_indexes]
            )

          {:jmp, val} ->
            run_until_idx_repeats(
              program,
              %{index: index + val, accumulator: accumulator},
              [index | used_indexes]
            )

          nil ->
            raise("Unknown operation.")
        end
      end
    end
  end

  def p1() do
    input()
    |> run_until_idx_repeats(%{index: 0, accumulator: 0}, [])
  end

  def attempt_to_fix(program, last_replaced_index) do
    case run_until_idx_repeats(program, %{index: 0, accumulator: 0}, []) do
      {memory, true} ->
        {memory, true}

      {memory, false} ->
        idx_for_op_to_change =
          input()
          |> Enum.drop(last_replaced_index + 1)
          |> Enum.find_index(fn {op, val} ->
            op == :nop || op == :jmp
          end)
          |> Kernel.+(last_replaced_index + 1)

        new_program =
          List.update_at(input(), idx_for_op_to_change, fn {op, val} ->
            case op do
              :nop ->
                {:jmp, val}

              :jmp ->
                {:nop, val}

              _ ->
                raise "No :nop or :jmp at index #{inspect(idx_for_op_to_change)}"
            end
          end)

        case attempt_to_fix(new_program, idx_for_op_to_change) do
          # program with replaced operation is ok
          {memory, true} ->
            {memory, true}

          # program with replaced operation is NOT ok,
          # so run the initial program but replace :nop/:jmp operation with higher index
          {memory, false} ->
            attempt_to_fix(input(), idx_for_op_to_change)
        end
    end
  end

  def p2() do
    input()
    |> attempt_to_fix(0)
  end
end

D.p1() |> IO.inspect(label: "part 1")
# %{accumulator: 1489, index: 163}

D.p2() |> IO.inspect(label: "part 2")
# %{accumulator: 1539, index: 601}
