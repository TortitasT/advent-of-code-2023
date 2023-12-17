defmodule App do
  def get_card_values(line) do
    line
    |> String.split(": ")
    |> List.last()
    |> String.split(" | ")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&Enum.map(&1, fn x -> String.trim(x) end))
    |> Enum.map(&Enum.filter(&1, fn x -> x != "" end))
    |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
  end

  def get_line_points(winning_numbers, card_values) do
    reduced =
      Enum.reduce(winning_numbers, 0, fn number, acc ->
        if number in card_values do
          acc + 1
        else
          acc
        end
      end)

    case reduced do
      0 -> 0
      1 -> 1
      _ -> :math.pow(2, reduced - 1)
    end
  end

  def main(_args) do
    file = File.stream!("input.txt")

    Enum.map(file, fn line ->
      [winning_numbers, card_values] = get_card_values(line)

      get_line_points(winning_numbers, card_values)
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end
