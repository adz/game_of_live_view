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

Initially, I used a LiveComponent for each cell. I read that this
compartmentalizes state, markup and events, so assumed it would be an 
independent process. After playing with them, I realise this, of course, 
isn't true - they run in the same process as the parent LiveView, the benefit
is they maintain their own carved out state from the parent, and events auto
delegate down from the LiveView -- which is why the id is important.

Implications were:
1) I couldn't make the cells live or die based on their process
2) Timer and update had to start from the parent LiveView, since the cells
aren't able to receive messages from other server processes

Some possible changes:
 - Use a LiveView for the child -- then we can have actual processes for them,
   and make the board just a coordinator. We still have no easy way of finding
   neighbours of a cell aside from playing with row/col offsets.

 - Use some Javascript DOM observation to detect 2) Timer and update had to start from the parent LiveView, since the cells
aren't able to receive messages from other server processes

---

Next, I changed the LiveComponent into a child LiveView so it was a fully
independent process. Implications:

 - Nothing rendered! The main problem was that the container for svg <rect>
HAD to be set to <svg> -- the docs seem to mention this in the context of
LiveComponent, but it only affected me here when using a child LiveView.

 - The parent couldn't address the children by id's based on col/row anymore.
Instead, they had to communicate up their pids which are kept in a map for later
reference.

I'd like to next go ahead and model the cells as more responsible for their own
behaviour, using the board/parent liveview only to broadcast to their neighbours.
