defmodule Solver do
  def compareLists(list1, list2) do
    # diff > 0 -> good
    # diff < 0 -> bad
    # diff = 0 -> check list lengths afterwards
    # Zipping will cut the list sizes to make them equally long
    diff =
      Enum.reduce(Enum.zip(list1, list2), 0, fn {item1, item2}, acc_diff ->
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

  def compare(list1, list2) do
    diff = Solver.compareLists(list1, list2)

    cond do
      diff == 0 -> :eq
      diff < 0 -> :gt
      true -> :lt
    end
  end

  def readFile() do
    {:ok, contents} = File.read("../input.txt")

    new1 = [[2]]
    new2 = [[6]]

    String.split(contents, "\n", trim: true)
    |> Enum.map(fn line -> Poison.decode!(line) end)
    |> Enum.concat([new1, new2])
    |> Enum.sort(Solver)
    |> Enum.with_index()
    |> Enum.reduce(1, fn {item, index}, acc ->
      cond do
        item == new1 or item == new2 -> acc * (index + 1)
        true -> acc
      end
    end)
    |> IO.inspect()
  end
end

Solver.readFile()
