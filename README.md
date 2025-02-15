# OdinPathfinding
A toy project for learning Odin and implementing some pathfinding/graph search algorithms

Controls:
Left click to toggle a tile as being passable/unpassable.
Press R to reset tiles to default.
Press S to set the start position to the mouse current position.
Press G to set the goal position to the mouse current position.
Press F1 to run depth first search from start (green) to goal (orange).
DFS does not mark route the route taken is every node visited.
Press F2 to run Breadth First Search from start (green) to goal (orange).
Best route will be colored purple (BFS will mark based on fewest tiles traversed, not cost).


TODO:
Weighted node values,
Djikstra's/UCS,
A*,


Might Do:
Animate search process

Done:
Depth First Search
Setable start/goal
Marking unvisited nodes in frontier(yellow), and visited (blue)
Breadth First Search
Mark shortest path purple
