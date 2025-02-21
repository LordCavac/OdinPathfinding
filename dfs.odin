package main

import rl "vendor:raylib"
import q "core:container/queue"

dfs :: proc(tilemap: ^TileMap, start: ^Tile, goal: ^Tile) -> bool {
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

        if isValid(visited, tilemap, rl.Vector2{loc.x+1, loc.y}) {
        q.push_front(&frontier, rl.Vector2{loc.x+1, loc.y})
        tilemap.grid[int(loc.x+1)][int(loc.y)].color = rl.YELLOW
        }
        if isValid(visited, tilemap, rl.Vector2{loc.x-1, loc.y}) {
        q.push_front(&frontier, rl.Vector2{loc.x-1, loc.y})
        tilemap.grid[int(loc.x-1)][int(loc.y)].color = rl.YELLOW
        }
        if isValid(visited, tilemap, rl.Vector2{loc.x, loc.y+1}) {
        q.push_front(&frontier, rl.Vector2{loc.x, loc.y+1})
        tilemap.grid[int(loc.x)][int(loc.y+1)].color = rl.YELLOW
        }
        if isValid(visited, tilemap, rl.Vector2{loc.x, loc.y-1}) {
        q.push_front(&frontier, rl.Vector2{loc.x, loc.y-1})
        tilemap.grid[int(loc.x)][int(loc.y-1)].color = rl.YELLOW
        }
    }

    return false
}
