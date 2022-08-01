defmodule GameOfLiveView.BoardTest do
  use ExUnit.Case
  alias GameOfLiveView.Board

  describe "Board" do
    setup do
      [
        empty: Board.empty(),
        filled: MapSet.new(for c <- 0..2, r <- 0..2, do: {c, r})
      ]
    end

    test "empty/0" do
      assert Board.empty() == MapSet.new()
    end

    test "will_live?/2", %{empty: empty_board, filled: filled} do
      # empty board is baron
      refute Board.will_live?(empty_board, {0, 0})
      refute Board.will_live?(empty_board, {1, 1})

      # Corners of filled 3x3 lives on (alive with 3 neighbours)
      assert Board.will_live?(filled, {0, 0})
      assert Board.will_live?(filled, {2, 2})
      assert Board.will_live?(filled, {0, 2})
      assert Board.will_live?(filled, {2, 0})
      # but non corners die -- too many neighbours
      refute Board.will_live?(filled, {1, 0})
      refute Board.will_live?(filled, {0, 1})
      refute Board.will_live?(filled, {1, 1})
      refute Board.will_live?(filled, {2, 1})
      refute Board.will_live?(filled, {1, 2})
    end

    test "update_board/3", %{empty: empty} do
      # brings life
      with_life = empty |> Board.update_board({0, 0}, true)
      assert with_life |> Board.alive?({0, 0})

      # doesn't dup
      assert with_life
             |> Board.update_board({0, 0}, true)
             |> Enum.count() == 1

      # brings death
      all_dead = with_life |> Board.update_board({0, 0}, false)
      refute all_dead |> Board.alive?({0, 0})
    end
  end
end
