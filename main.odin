package main

import rl "vendor:raylib"
import "core:fmt"
import "core:container/queue"
import "core:strings"
import "core:strconv"

SCREENX :: 1920
SCREENY :: 1080
TILESIZE :: 64
WORLDX :: int(SCREENX/TILESIZE)
WORLDY :: int(SCREENY/TILESIZE) + 1

// Until I started digging through the built-in queue I didn't realize that Odin used queue as both a stack and queue. Here is a good example for paramorphic types and functions though.
// Stack :: struct($T: typeid) {
//     data: []T,
// }
// push :: proc(stack: ^$Stack, value: $T) {
//     stack.data = append(&stack.data, value)
// }
// pop :: proc(stack: ^$Stack/Stack($T)) -> T {
//     if len(stack.data) == 0 {
//         fmt.eprintf("Stack already empty!\n")
//         return zero(T)
//     }
//     value := stack.data[len(stack.data) - 1]
//     stack.data = stack.data[:len(stack.data) - 1]
//     return value
// }
// isEmpty :: proc(stack: ^$Stack) -> bool {
//     return len(stack.data) == 0
// }

Tile :: struct {
    passable: bool,
    color: rl.Color,
    position: rl.Rectangle,
    previous: ^Tile, // When searching, used to keep track of the node that was come from
    cost: int, // cost of leaving this tile
    totalCost: int, // cost of reaching this tile
}

TileMap :: struct {
    grid: [WORLDX][WORLDY]Tile,
}

// Used by algorithms to determine if a tile is valid for movement.
isValid :: proc(visited: [$N][$M]bool, tilemap: ^TileMap, loc: rl.Vector2) -> bool {
    // fmt.eprintf("Checking if %v, %v is valid\n", loc.x, loc.y)
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

markPath :: proc(start: ^Tile, goal: ^Tile) {
    current := goal.previous
    for current != start {
        current.color = rl.PURPLE
        current = current.previous
    }
}

// Initializes the tilemap to a default empty/passible state
setTileMap :: proc(tilemap: ^TileMap) {
    for x := 0; x < WORLDX; x += 1 {
        for y := 0; y < WORLDY; y += 1 {
            tile := Tile {
                passable = true,
                color = rl.BLACK,
                position = {f32(x * TILESIZE), f32(y * TILESIZE), TILESIZE, TILESIZE},
                previous = nil,
                cost = 1,
                totalCost = 0,
            }
            tilemap.grid[x][y] = tile
        }
    }
}

main :: proc() {
    rl.InitWindow(1920, 1080, "Search Demonstration")
    // rl.SetWindowState({.WINDOW_RESIZABLE})
    rl.SetTargetFPS(500)
    
    // Initialize tiles in tilemap
    tilemap: TileMap
    setTileMap(&tilemap)

    start: ^Tile = &tilemap.grid[0][0]
    start.color = rl.GREEN
    goal: ^Tile = &tilemap.grid[WORLDX-1][WORLDY-1]
    goal.color = rl.ORANGE

    camera := rl.Camera2D{offset = {0,0}, target = {0,0}, rotation = 0, zoom = 1.0}

    // BEGIN GAME LOOP################################################################################
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.BeginMode2D(camera)

        for x := 0; x < WORLDX; x += 1 {
            for y := 0; y < WORLDY; y += 1 {
                rl.DrawRectangleRec(tilemap.grid[x][y].position, tilemap.grid[x][y].color)
                buf: [4]byte
                costText: string = strconv.itoa(buf[:] ,tilemap.grid[x][y].cost)
                rl.DrawText(strings.clone_to_cstring(costText), i32(tilemap.grid[x][y].position.x + TILESIZE/2.5),i32(tilemap.grid[x][y].position.y + TILESIZE/4), 32, rl.WHITE)
            }
        }

        mp := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)

        if rl.IsMouseButtonPressed(.LEFT) {
            for x := 0; x < WORLDX; x += 1 {
                for y := 0; y < WORLDY; y += 1 {
                    if rl.CheckCollisionPointRec(mp, tilemap.grid[x][y].position) {
                        tilemap.grid[x][y].passable = !tilemap.grid[x][y].passable
                        if tilemap.grid[x][y].passable {
                            tilemap.grid[x][y].color = rl.BLACK
                        } else {
                            tilemap.grid[x][y].color = rl.RED
                        }
                    }
                }
            }
        }

        if rl.IsKeyPressed(.S) {
            for x := 0; x < WORLDX; x += 1 {
                for y := 0; y < WORLDY; y += 1 {
                    if rl.CheckCollisionPointRec(mp, tilemap.grid[x][y].position) {
                        start.color = rl.BLACK
                        start = &tilemap.grid[x][y]
                        start.color = rl.GREEN
                    }
                }
            }
        }

        if rl.IsKeyPressed(.G) {
            for x := 0; x < WORLDX; x += 1 {
                for y := 0; y < WORLDY; y += 1 {
                    if rl.CheckCollisionPointRec(mp, tilemap.grid[x][y].position) {
                        goal.color = rl.BLACK
                        goal = &tilemap.grid[x][y]
                        goal.color = rl.ORANGE
                    }
                }
            }
        }

        if rl.IsKeyPressed(.ONE) {
            for x := 0; x < WORLDX; x += 1 {
                for y := 0; y < WORLDY; y += 1 {
                    if rl.CheckCollisionPointRec(mp, tilemap.grid[x][y].position) {
                        tilemap.grid[x][y].cost = 1
                    }
                }
            }
        }

        if rl.IsKeyPressed(.TWO) {
            for x := 0; x < WORLDX; x += 1 {
                for y := 0; y < WORLDY; y += 1 {
                    if rl.CheckCollisionPointRec(mp, tilemap.grid[x][y].position) {
                        tilemap.grid[x][y].cost = 2
                    }
                }
            }
        }

        if rl.IsKeyPressed(.THREE) {
            for x := 0; x < WORLDX; x += 1 {
                for y := 0; y < WORLDY; y += 1 {
                    if rl.CheckCollisionPointRec(mp, tilemap.grid[x][y].position) {
                        tilemap.grid[x][y].cost = 3
                    }
                }
            }
        }

        if rl.IsKeyPressed(.FOUR) {
            for x := 0; x < WORLDX; x += 1 {
                for y := 0; y < WORLDY; y += 1 {
                    if rl.CheckCollisionPointRec(mp, tilemap.grid[x][y].position) {
                        tilemap.grid[x][y].cost = 4
                    }
                }
            }
        }

        if rl.IsKeyPressed(.FIVE) {
            for x := 0; x < WORLDX; x += 1 {
                for y := 0; y < WORLDY; y += 1 {
                    if rl.CheckCollisionPointRec(mp, tilemap.grid[x][y].position) {
                        tilemap.grid[x][y].cost = 5
                    }
                }
            }
        }

        if rl.IsKeyPressed(.R) {
            setTileMap(&tilemap)
            start.color = rl.GREEN
            goal.color = rl.ORANGE
        }

        if rl.IsKeyPressed(.F1) {
            dfs(&tilemap, start, goal)
            start.color = rl.GREEN
            goal.color = rl.ORANGE
        }

        if rl.IsKeyPressed(.F2) {
            bfs(&tilemap, start, goal)
            start.color = rl.GREEN
            goal.color = rl.ORANGE
        }

        if rl.IsKeyPressed(.F3) {
            ucs(&tilemap, start, goal)
            start.color = rl.GREEN
            goal.color = rl.ORANGE
        }

        if rl.IsKeyPressed(.F4) {
            aStar(&tilemap, start, goal)
            start.color = rl.GREEN
            goal.color = rl.ORANGE
        }

        rl.EndMode2D()
        rl.EndDrawing()
    }

    rl.CloseWindow()
}