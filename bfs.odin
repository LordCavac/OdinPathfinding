package main

import rl "vendor:raylib"
import q "core:container/queue"


bfs :: proc(tilemap: ^TileMap, start: ^Tile, goal: ^Tile) -> bool {
    gridLoc := rl.Vector2 {start.position.x / TILESIZE, start.position.y / TILESIZE}
    frontier: q.Queue(rl.Vector2)
    visited: [WORLDX][WORLDY]bool
    q.push_front(&frontier, gridLoc)
    
    for q.len(frontier) != 0 {
        loc := q.pop_front(&frontier)
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
                q.push_back(&frontier, neighbor)
                tilemap.grid[int(neighbor.x)][int(neighbor.y)].previous = &tilemap.grid[int(loc.x)][int(loc.y)]
                tilemap.grid[int(neighbor.x)][int(neighbor.y)].color = rl.YELLOW
            }
        }
    }

    return false
}
