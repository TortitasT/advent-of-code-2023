defmodule Mix.Tasks.Exec do
  use Mix.Task

  defp handle_line_label(line) do
    [label, lineWithoutLabel] = String.split(line, ": ")
    [_, id] = String.split(label, " ")

    {id, lineWithoutLabel}
  end

  @impl Mix.Task
  def run(_args) do
    lines =
      File.read!("input.txt")
      |> String.split("\n", trim: true)

    maxRed = 12
    maxGreen = 13
    maxBlue = 14

    lines =
      Enum.map(lines, fn line ->
        {id, lineWithoutLabel} = handle_line_label(line)

        sets = String.split(lineWithoutLabel, "; ")

        sets =
          Enum.map(sets, fn set ->
            splits = String.split(set, ", ")

            totals = %{red: 0, green: 0, blue: 0}

            Enum.reduce(splits, totals, fn split, totals ->
              case totals do
                nil ->
                  nil

                _ ->
                  [number, label] = String.split(split, " ")

                  label = String.to_atom(label)
                  number = Integer.parse(number) |> elem(0)

                  newTotal = totals[label] + number

                  case label do
                    :red ->
                      if newTotal > maxRed do
                        nil
                      else
                        Map.update!(totals, :red, fn x -> newTotal end)
                      end

                    :green ->
                      if newTotal > maxGreen do
                        nil
                      else
                        Map.update!(totals, :green, fn x -> newTotal end)
                      end

                    :blue ->
                      if newTotal > maxBlue do
                        nil
                      else
                        Map.update!(totals, :blue, fn x -> newTotal end)
                      end
                  end
              end
            end)
          end)

        {
          id,
          sets |> Enum.any?(fn x -> x == nil end) == false
        }
      end)

    sumOfIds =
      lines
      |> Enum.filter(fn {_, viable} -> viable end)
      |> Enum.map(fn {id, _} -> Integer.parse(id) |> elem(0) end)
      |> Enum.sum()

    IO.inspect(sumOfIds)
  end
end
