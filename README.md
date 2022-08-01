# GameOfLiveView

As a fun experiment, build out a board by creating processes for each cell as it
is rendered. In the browser, they can send messages to their neighbours, who
delegate back to their server process.

The board itself doesn't call logic -- it's simply a side effect of creating cells in
a specific order, with positions coordinated with neighbours.

Cell data would be:

  * row, col: int -- positional data created on gen
  * alive: bool
  * alive_neighbours: int -- number of alive neighbours in this iteration
