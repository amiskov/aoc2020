defmodule Day7 do
  # TODO: take a look at :digraph
  def input() do
    File.read!("inputs/day7")
    # File.read!("inputs/day7_sample")
    # File.read!("inputs/day7_sample2")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_colors/1)
    |> Map.new()
  end

  def parse_colors(l) do
    r = ~r/^(?<container>\w+\s\w+)\sbags contain (?<raw_content>.*).$/
    regex_inner_colors = ~r/(?<qty>\d+)\s(?<raw_color>\w+\s\w+)/

    %{"container" => container, "raw_content" => raw_content} = Regex.named_captures(r, l)

    inner_colors =
      raw_content
      |> String.split(",")
      |> Enum.map(fn l ->
        if(l != "no other bags") do
          %{"qty" => q, "raw_color" => c} = Regex.named_captures(regex_inner_colors, l)
          {to_color_name(c), q |> String.to_integer()}
        end
      end)
      |> (&if(&1 == [nil], do: [], else: &1)).()

    {container |> to_color_name(), inner_colors |> Map.new()}
  end

  def to_color_name(s), do: s |> String.replace(" ", "_") |> String.to_atom()

  def p1 do
    input()
    |> find_parents(:shiny_gold)
    |> MapSet.size()
  end

  def find_parents(rules, c) do
    rules
    |> fp_inner(MapSet.new([c]), MapSet.new())
  end

  def fp_inner(rules, colors_to_find, acc) do
    if rules == [] do
      acc
    else
      # надо чтобы хотябы один из colors_to_find входил в inner_colors текущего правила
      parent_colors =
        rules
        |> Enum.filter(fn {_k, v} ->
          current_inner_colors = Map.keys(v) |> MapSet.new()

          MapSet.intersection(colors_to_find, current_inner_colors)
          |> MapSet.size() > 0
        end)
        |> Enum.map(fn {k, _v} -> k end)
        |> MapSet.new()

      if MapSet.size(parent_colors) == 0 do
        acc
      else
        new_rules =
          rules
          |> Enum.filter(fn {k, _v} ->
            not MapSet.member?(parent_colors, k)
          end)

        fp_inner(new_rules, parent_colors, MapSet.union(acc, parent_colors))
      end
    end
  end

  def p2 do
    input()
    |> find_children(:shiny_gold)
    |> Enum.sum()
  end

  def find_children(rules, color) do
    # color not counts, only children
    fc_inner(rules, color)
  end

  def fc_inner(rules, color) do
    Map.get(rules, color)
    |> Enum.map(fn {cl, qty} ->
      res = fc_inner(rules, cl)

      if res == [] do
        qty
      else
        qty * Enum.sum(res) + qty
      end
    end)
  end
end

# (Day7.p2() == 2976) |> IO.inspect(label: "part 2 is correct")
# (Day7.p1() == 246) |> IO.inspect(label: "part 1 is correct")
