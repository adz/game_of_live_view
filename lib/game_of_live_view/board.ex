defmodule GameOfLiveView.Board do
  # board represented by set of living cell coords
  def empty do
    MapSet.new()
  end

  # TODO: tdd
  # neighbours of cells who are not alive
  def zombies(board) do
    []
  end

  def will_live?(board, cell) do
    alive = alive?(board, cell)
    live_neighbours = count_neighbours(board, cell)

    passes_life_rule?(alive, live_neighbours)
  end

  def passes_life_rule?(alive, live_neighbours) do
    (alive && live_neighbours == 2) || live_neighbours == 3
  end

  def update_board(board, fresh_cell, alive) do
    if alive do
      board |> MapSet.put(fresh_cell)
    else
      board |> MapSet.delete(fresh_cell)
    end
  end

  def alive?(board, cell) do
    board |> Enum.member?(cell)
  end

  defp count_neighbours(board, cell) do
    cell
    |> get_neighbours()
    |> Enum.count(fn neighbour -> board |> alive?(neighbour) end)
  end

  defp get_neighbours({col, row} = _cell) do
    # generate offsets around the cell
    for col_off <- -1..1, row_off <- -1..1 do
      {col - col_off, row - row_off}
    end
    |> List.delete({col, row})
  end
end
