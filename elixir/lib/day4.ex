defmodule Passport do
  @enforce_keys [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
  defstruct @enforce_keys ++ [:cid]

  @type t() :: %__MODULE__{
          byr: String.t(),
          iyr: String.t(),
          eyr: String.t(),
          hgt: String.t(),
          hcl: String.t(),
          ecl: String.t(),
          pid: String.t(),
          cid: any() | nil
        }
end

defmodule Day4 do
  def input() do
    File.read!("inputs/day4")
    # File.read!("inputs/day4_sample")
    # File.read!("inputs/day4_invalid")
    # File.read!("inputs/day4_valid")
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(l) do
    fields =
      l
      |> String.split(~r{\s}, trim: true)
      |> Enum.map(fn field ->
        [k, v] = String.split(field, ":")

        {String.to_atom(k), v}
      end)

    try do
      struct!(Passport, fields)
    rescue
      _ ->
        nil
    end
  end

  def fields_present?(%Passport{}), do: true

  def fields_present?(_), do: false

  def part1(), do: input() |> Enum.filter(&fields_present?/1) |> Enum.count()

  def part2(),
    do:
      input()
      |> Enum.filter(&fields_present?/1)
      |> Enum.filter(&to_valid_passport/1)
      |> Enum.count()

  def to_valid_passport(%Passport{
        byr: byr,
        iyr: iyr,
        eyr: eyr,
        hgt: hgt,
        hcl: hcl,
        ecl: ecl,
        pid: pid,
        cid: cid
      }) do
    valid_fields =
      [
        byr: to_byr(byr),
        iyr: to_iyr(iyr),
        eyr: to_eyr(eyr),
        hgt: to_hgt(hgt),
        hcl: to_hcl(hcl),
        ecl: to_ecl(ecl),
        pid: to_pid(pid)
      ]
      |> Enum.filter(fn {_, v} -> not is_nil(v) end)

    if Enum.count(valid_fields) == 7 do
      struct(Passport, valid_fields ++ [cid: cid])
    else
      nil
    end
  end

  def to_byr(s), do: to_valid_range(s, 1920, 2002)

  def to_iyr(s), do: to_valid_range(s, 2010, 2020)

  def to_eyr(s), do: to_valid_range(s, 2020, 2030)

  def to_valid_range(s, min, max) do
    # four digits; at least `min` and at most `max`
    y = String.to_integer(s)

    if y >= min and y <= max do
      s
    else
      nil
    end
  end

  def to_hgt(s) do
    # hgt (Height) - a number followed by either cm or in:
    # If cm, the number must be at least 150 and at most 193.
    # If in, the number must be at least 59 and at most 76.
    %{"n" => num, "u" => unit} = Regex.named_captures(~r/^(?<n>\d+)(?<u>\w+)$/, s)

    case unit do
      "cm" ->
        to_valid_range(num, 150, 193)

      "in" ->
        to_valid_range(num, 59, 76)

      _ ->
        nil
    end
  end

  def to_hcl(s) do
    # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    # hcl valid:   #123abc
    # hcl invalid: #123abz
    # hcl invalid: 123abc
    if Regex.match?(~r/^#[0-9a-f]{6}$/, s) do
      s
    else
      nil
    end
  end

  def to_ecl(ecl) do
    # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    case ecl do
      "amb" ->
        ecl

      "blu" ->
        ecl

      "brn" ->
        ecl

      "gry" ->
        ecl

      "grn" ->
        ecl

      "hzl" ->
        ecl

      "oth" ->
        ecl

      _ ->
        nil
    end
  end

  def to_pid(s) do
    # pid (Passport ID) - a nine-digit number, including leading zeroes.
    if Regex.match?(~r/^\d{9}$/, s) do
      s
    else
      nil
    end
  end
end

# Day4.part1()
# |> IO.inspect()

# Day4.part2()
# |> IO.inspect()
