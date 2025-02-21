package main

import rl "vendor:raylib"

findLowestEstimatedCost :: proc(frontier: ^[dynamic]rl.Vector2, tilemap: ^TileMap, goalLoc: rl.Vector2) -> rl.Vector2 {
    selIdx: int = 0
    selNode: rl.Vector2 = frontier[0]
    selNodeHeur: int = abs(int(selNode.x - goalLoc.x)) + abs(int(selNode.y - goalLoc.y))

    for i: int = 0; i < len(frontier); i += 1 {
        heur: int = abs(int(frontier[i].x - goalLoc.x)) + abs(int(frontier[i].y - goalLoc.y))
        if tilemap.grid[int(frontier[i].x)][int(frontier[i].y)].cost + tilemap.grid[int(frontier[i].x)][int(frontier[i].y)].totalCost + heur < tilemap.grid[int(selNode.x)][int(selNode.y)].cost + tilemap.grid[int(selNode.x)][int(selNode.y)].totalCost + selNodeHeur {
            selNode = frontier[i]
            selNodeHeur = heur
            selIdx = i
        }
    }

    unordered_remove(frontier, selIdx)

    return selNode
}

aStar :: proc(tilemap: ^TileMap, start: ^Tile, goal: ^Tile) -> bool {
    loc := rl.Vector2 {start.position.x / TILESIZE, start.position.y / TILESIZE}
    goalLoc := rl.Vector2 {goal.position.x / TILESIZE, goal.position.y / TILESIZE}
    frontier: [dynamic]rl.Vector2
    visited: [WORLDX][WORLDY]bool
    append(&frontier, loc)
    
    for len(frontier) != 0 {
        loc = findLowestEstimatedCost(&frontier, tilemap, goalLoc)
        if !isValid(visited, tilemap, loc) {
            continue
        }

        if &tilemap.grid[int(loc.x)][int(loc.y)] == goal {
            markPath(start, goal)
            return true
        }

        visited[int(loc.x)][int(loc.y)] = true
        tilemap.grid[int(loc.x)][int(loc.y)].color = rl.BLUE

        neighbors := [4]rl.Vector2{rl.Vector2{loc.x+1, loc.y}, rl.Vector2{loc.x-1, loc.y}, rl.Vector2{loc.x, loc.y+1}, rl.Vector2{loc.x, loc.y-1}}
        for neighbor in neighbors {
            if isValid(visited, tilemap, neighbor) {
                append(&frontier, neighbor)
                tilemap.grid[int(neighbor.x)][int(neighbor.y)].previous = &tilemap.grid[int(loc.x)][int(loc.y)]
                tilemap.grid[int(neighbor.x)][int(neighbor.y)].color = rl.YELLOW
                tilemap.grid[int(neighbor.x)][int(neighbor.y)].totalCost = tilemap.grid[int(loc.x)][int(loc.y)].cost + tilemap.grid[int(loc.x)][int(loc.y)].totalCost
            }
        }
    }

    return false
}