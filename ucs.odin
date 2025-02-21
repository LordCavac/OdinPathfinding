package main

import rl "vendor:raylib"

findLowestCost :: proc(frontier: ^[dynamic]rl.Vector2, tilemap: ^TileMap) -> rl.Vector2 {
    selIdx: int = 0
    selNode: rl.Vector2 = frontier[0]
    for i: int = 0; i < len(frontier); i += 1 {
        if tilemap.grid[int(frontier[i].x)][int(frontier[i].y)].cost + tilemap.grid[int(frontier[i].x)][int(frontier[i].y)].totalCost < tilemap.grid[int(selNode.x)][int(selNode.y)].cost + tilemap.grid[int(selNode.x)][int(selNode.y)].totalCost {
            selNode = frontier[i]
            selIdx = i
        }
    }

    unordered_remove(frontier, selIdx)

    return selNode
}

ucs :: proc(tilemap: ^TileMap, start: ^Tile, goal: ^Tile) -> bool {
    gridLoc := rl.Vector2 {start.position.x / TILESIZE, start.position.y / TILESIZE}
    frontier: [dynamic]rl.Vector2
    visited: [WORLDX][WORLDY]bool
    append(&frontier, gridLoc)
    
    for len(frontier) != 0 {
        loc := findLowestCost(&frontier, tilemap)
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