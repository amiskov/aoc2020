defmodule Day2 do
  def input() do
    # File.read!("inputs/day2_sample")
    File.read!("inputs/day2")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(l) do
    regex = ~r/\A(\d+)-(\d+) (\w): (\w+)\z/
    [f, s, l, p] = Regex.run(regex, l, capture: :all_but_first)

    %{
      first: String.to_integer(f),
      second: String.to_integer(s),
      letter: l,
      password: p
    }
  end

  def check_password1(%{letter: letter, first: first, second: second, password: password} = data) do
    count =
      String.split(password, "", trim: true)
      |> Enum.filter(fn l -> l == letter end)
      |> Enum.count()

    is_correct = count >= first && count <= second
    Map.put(data, :is_correct, is_correct)
  end

  def add_positions(%{letter: letter, first: first, second: second, password: password} = data) do
    Map.put(data, :is_at_first, String.at(password, first - 1) == letter)
    |> Map.put(:is_at_second, String.at(password, second - 1) == letter)
  end

  def valid_passwords1(parsed_input) do
    Enum.map(parsed_input, &check_password1/1)
  end

  def valid_passwords2(parsed_input) do
    Enum.map(parsed_input, &add_positions/1)
  end

  def check_exactly_one(data) do
    # Exactly one of these positions must contain the given letter.
    (data.is_at_first && !data.is_at_second) ||
      (data.is_at_second && !data.is_at_first)
  end
end

# Part 1
Day2.input()
|> Day2.valid_passwords1()
|> Enum.filter(fn el -> el.is_correct end)
|> Enum.count()
|> IO.inspect()

# Part 2
Day2.input()
|> Day2.valid_passwords2()
|> Enum.filter(&Day2.check_exactly_one/1)
|> Enum.count()
|> IO.inspect()
