package main

import rl "vendor:raylib"
import q "core:container/queue"
import "core:fmt"

isValid :: proc(visited: [$N][$M]bool, tilemap: ^TileMap, loc: rl.Vector2) -> bool {
    fmt.eprintf("Checking if %v, %v is valid\n", loc.x, loc.y)
    if int(loc.x) == WORLDX || int(loc.y) == WORLDY || int(loc.x) < 0 || int(loc.y) < 0 {
        return false
    }
    if visited[int(loc.x)][int(loc.y)] {
        return false
    }
    if !tilemap.grid[int(loc.x)][int(loc.y)].passable {
        return false
    }
    return true
}


dfs :: proc(tilemap: ^TileMap, start: ^Tile, goal: ^Tile) -> bool {
    fmt.eprintf("Starting Depth Search\n")
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
            return true
        }

        visited[int(loc.x)][int(loc.y)] = true
        tilemap.grid[int(loc.x)][int(loc.y)].color = rl.BLUE

        q.push_front(&frontier, rl.Vector2{loc.x+1, loc.y})
        q.push_front(&frontier, rl.Vector2{loc.x-1, loc.y})
        q.push_front(&frontier, rl.Vector2{loc.x, loc.y+1})
        q.push_front(&frontier, rl.Vector2{loc.x, loc.y-1})
    }

    return false
}
