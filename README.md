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

In this version, I used a LiveComponent for each cell. I read that this
compartmentalizes state, markup and events, so assumed it would be an 
independent process. After playing with them, I realise this, of course, 
isn't true - they run in the same process as the parent LiveView, the benefit
is they maintain their own carved out state from the parent, and events auto
delegate down from the LiveView -- which is why the id is important.

Implications for this project are:
1) I couldn't make the cells live or die based on their process
2) Timer and update had to start from the parent LiveView, since the cells
aren't able to receive messages from other server processes

Some possible changes:
 - Use a LiveView for the child -- then we can have actual processes for them,
   and make the board just a coordinator. We still have no easy way of finding
   neighbours of a cell aside from playing with row/col offsets.

 - Use some Javascript DOM observation to detect 2) Timer and update had to start from the parent LiveView, since the cells
aren't able to receive messages from other server processes

Some possible changes:
 - Use a LiveView for the child -- then we can have actual processes for them,
   and make the board just a coordinator. We still have no easy way of finding
   neighbours of a cell aside from playing with row/col offsets.

 - Use a transparent border, and overlap the cells, then add some Javascript 
   DOM observation to detect which cells overlap. Then, I could send an event 
   to each cell LiveComponent on the server via pushEventTo. The idea here is
   to better model 'live' and the cells could count up the number of events 
   received, and self-regulate the next iteration. 

   The board may have to coordinate timing, such that these events broadcasting
   to indicate live to neighbours is totally completed before the self-regulation
   occurs.