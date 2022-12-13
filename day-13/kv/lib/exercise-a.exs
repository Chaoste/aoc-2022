defmodule Solver do
  def compareLists(list1, list2) do
    # diff > 0 -> good
    # diff < 0 -> bad
    # diff = 0 -> check list lengths afterwards
    # Zipping will cut the list sizes to make them equally long
    diff =
      Enum.reduce(Enum.zip(list1, list2), 0, fn {item1, item2}, acc_diff ->
        # IO.puts("Check: #{item1}, #{item2}")
        cond do
          acc_diff > 0 or acc_diff < 0 -> acc_diff
          # Both are numbers, the left one may not be greater
          !is_list(item1) and !is_list(item2) -> item2 - item1
          is_list(item1) and is_list(item2) -> Solver.compareLists(item1, item2)
          is_list(item1) and !is_list(item2) -> Solver.compareLists(item1, [item2])
          !is_list(item1) and is_list(item2) -> Solver.compareLists([item1], item2)
          true -> true
        end
      end)

    cond do
      # The right list may never have a smaller size
      diff == 0 -> length(list2) - length(list1)
      true -> diff
    end
  end

  def readFile() do
    {:ok, contents} = File.read("../input.txt")
    lines = String.split(contents, "\n", trim: true)

    indizes =
      Enum.map(Enum.with_index(Enum.chunk_every(lines, 2, 2)), fn {[line1, line2], index} ->
        # IO.puts("New pair: #{index + 1} #{line1} #{line2}")
        {_, list1} = Poison.decode(line1)
        {_, list2} = Poison.decode(line2)
        result = Solver.compareLists(list1, list2)
        # IO.puts("##{index + 1}: #{result}")

        cond do
          result >= 0 -> index + 1
          true -> 0
        end
      end)

    # IO.inspect(indizes)

    IO.puts("Sum of indizes: #{Enum.sum(indizes)}")
  end
end

Solver.readFile()
