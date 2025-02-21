# OdinPathfinding
A toy project for learning Odin and implementing some pathfinding/graph search algorithms

Controls:
Left click to toggle a tile as being passable/unpassable.
Press R to reset tiles to default.
Press S to set the start position to the mouse current position.
Press G to set the goal position to the mouse current position.
Use 1-5 to set the cost to move through the mouse current position (only considered in UCS and A*).
Press F1 to run depth first search from start (green) to goal (orange).
Press F2 to run Breadth First Search from start (green) to goal (orange).
Press F3 to run Uniform Cost Search from start (green) to goal (orange).
Press F4 to run A* from start (green) to goal (orange).
Best route will be colored purple (BFS will mark based on fewest tiles traversed, not cost).
DFS does not mark route, the route taken is every node visited.


TODO:

Might Do:
Animate search process

Done:
Depth First Search
Setable start/goal
Marking unvisited nodes in frontier(yellow), and visited (blue)
Breadth First Search
Mark shortest path purple
Weighted node values
Djikstra's/UCS
A*
