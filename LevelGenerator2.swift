//
//  LevelGenerator.swift
//  GravityPuzzle
//
//  Created by Casey Manning on 7/15/16.
//  Copyright © 2016 Casey Manning. All rights reserved.
//

import Foundation
import SpriteKit

class LevelGenerator2 {
    
    //how many blocks there are
    var numBlocks = 4
    var g: GameScene
    var maxMoves = 20
    
    // Initialize with existing scene
    init(scene: GameScene) {
        g = scene
    }
    
    func generateNewLevel() -> [[Block]] {
        
        // infinte loop
        while true {
            // create random Map
            let map: [[Int]] = randomMap()
            print("Generating a random map...")
            if isDecent(map) && playThroughLevel(map, playerPosition: CGPoint(x: 1, y: 1), numMoves: 0) {
                
                
                var retMap: [[Block]] = []
                for list in map {
                    var blockList: [Block] = []
                    for int in list {
                        blockList.append(Block(id: int))
                    }
                    retMap.append(blockList)
                }
                // break out of loop
                return retMap
            }
            
        }
    }
    
    func randomMap() -> [[Int]] {
        // Make new 2d array
        var ret = [[Int]]()
        // 2d zero array
        ret.append([Int](count: 4, repeatedValue: 0))
        ret.append([Int](count: 4, repeatedValue: 0))
        ret.append([Int](count: 4, repeatedValue: 0))
        ret.append([Int](count: 4, repeatedValue: 0))
        
        for (i, list) in ret.enumerate() {
            for (j, _) in list.enumerate() {
                ret[i][j] = randomTile()
            }
        }
        
        return ret
    }
    
    func randomTile() -> Int {
        // Generate a kind of block randomly
        let a = Int(Double(arc4random())/Double(UInt32.max) * Double(3))
        if a < 2 {
            return 0
        }
        return 1
    }
    
    // recursively play through level
    func playThroughLevel(map: [[Int]], playerPosition: CGPoint, numMoves: Int) -> Bool {
        
        // capped at 5
        var moves = numMoves
        
        // if dead return
        // (no gravity yet)
        if map[Int(playerPosition.y)][Int(playerPosition.x)] != 0 {
            return false
        }
        
        // escape if too deep
        if numMoves > maxMoves {
            if playerPosition.x > 1 {
                
            }
            return true
            
        }
        moves += 1
        
        // some random flag
        var r = false
        while r {
            // floodgates
            let rand = Int(Double(arc4random())/Double(UInt32.max) * Double(6))
            
            if rand == 1 {
                if canMoveLeft(map, playerPosition: playerPosition) {
                    let f = moveLeft(map, playerPosition: playerPosition)
                    if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: moves) == true {
                        r = true
                    }
                    
                }
            } else if rand == 2 {
                if canMoveRight(map, playerPosition: playerPosition) {
                    let f = moveRight(map, playerPosition: playerPosition)
                    if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: moves) == true {
                        r = true
                    }
                    
                }
            } else if rand == 3 {
                if canRotateRight(map, playerPosition: playerPosition) {
                    let f = rotateRight(map, playerPosition: playerPosition)
                    if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: moves) == true {
                        r = true
                    }
                    
                }
            } else if rand == 4 {
                if canRotateLeft(map, playerPosition: playerPosition) {
                    let f = rotateLeft(map, playerPosition: playerPosition)
                    if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: moves) == true {
                        r = true
                    }
                    
                }
            } else if rand == 5 {
                if canUpRight(map, playerPosition: playerPosition) {
                    let f = moveUpRight(map, playerPosition: playerPosition)
                    if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: numMoves) == true {
                        r = true
                    }
                    
                }
            } else if rand == 0 {
                if canUpLeft(map, playerPosition: playerPosition) {
                    let f = moveUpLeft(map, playerPosition: playerPosition)
                    if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: numMoves) == true {
                        r = true
                    }
                }
            }
        }
        //playerPosition.x += 1
        
        return r
    }
    
    func isDecent(map: [[Int]]) -> Bool {
        var goals = 0
        var connects = 0
        for list in map {
            for block in list {
                if block == 2 {
                    goals += 1
                }
                if block == 3 {
                    connects += 1
                }
            }
        }
        if goals > 1 {
            return false
        }
        if connects > 2 {
            return false
        }
        if goals == 1 && connects > 0 {
            return false
        }
        if connects == 2 && goals > 0 {
            return false
        }
        if connects < 2 && goals < 1 {
            return false
        }
        
        if g.won(map, x: 1, y: 1) {
            return false
        }
        
        print("Found a decent map")
        return true
    }
    
    func canMoveLeft(map: [[Int]], playerPosition: CGPoint) -> Bool {
        if playerPosition.x < 1 {
            return false
        }
        if map[Int(playerPosition.y)][Int(playerPosition.x-1)] != 0 {
            return true
        }
        if playerPosition.x < 2 {
            return false
        }
        return map[Int(playerPosition.y)][Int(playerPosition.x-2)] != 0
    }
    
    func canMoveRight(map: [[Int]], playerPosition: CGPoint) -> Bool {
        if Int(playerPosition.x) > map[0].count - 2 {
            return false
        }
        
        if map[Int(playerPosition.y)][Int(playerPosition.x+1)] != 0 {
            return true
        }
        if Int(playerPosition.x) > map[0].count - 3 {
            return false
        }
        return map[Int(playerPosition.y)][Int(playerPosition.x+2)] != 0
    }
    
    func canRotateLeft(map: [[Int]], playerPosition: CGPoint) -> Bool {
        return true
    }
    
    func canRotateRight(map: [[Int]], playerPosition: CGPoint) -> Bool {
        return true
    }
    
    func canUpLeft(map: [[Int]], playerPosition: CGPoint) -> Bool {
        if playerPosition.x < 1 || playerPosition.y < 1 {
            return false
        }
        return map[Int(playerPosition.y)][Int(playerPosition.x-1)] != 0 && map[Int(playerPosition.y-1)][Int(playerPosition.x-1)] == 0
    }
    
    func canUpRight(map: [[Int]], playerPosition: CGPoint) -> Bool {
        if Int(playerPosition.x) > map[0].count - 2 || playerPosition.y < 1 {
            return false
        }
        return map[Int(playerPosition.y)][Int(playerPosition.x+1)] != 0 && map[Int(playerPosition.y-1)][Int(playerPosition.x+1)] == 0
    }
    
    func moveLeft(map: [[Int]], playerPosition: CGPoint) -> (map: [[Int]], x: Int, y: Int) {
        var happyMap: [[Int]] = []
        for list in map {
            happyMap.append(list)
        }
        var playerX = Int(playerPosition.x)
        let playerY = Int(playerPosition.y)
        playerX -= 1
        if playerX > 0 {
            if(happyMap[playerY][playerX] != 0) {
                happyMap[playerY][playerX - 1] = happyMap[playerY][playerX]
                happyMap[playerY][playerX] = 0
            }
        }
        return (happyMap, playerX, playerY)
    }
    
    func moveRight(map: [[Int]], playerPosition: CGPoint) -> (map: [[Int]], x: Int, y: Int) {
        var happyMap: [[Int]] = []
        for list in map {
            happyMap.append(list)
        }
        var playerX = Int(playerPosition.x)
        let playerY = Int(playerPosition.y)
        playerX += 1
        if playerX < happyMap[0].count - 1 {
            if(happyMap[playerY][playerX] != 0) {
                happyMap[playerY][playerX + 1] = happyMap[playerY][playerX]
                happyMap[playerY][playerX] = 0
            }
        }
        return (happyMap, playerX, playerY)
    }
    
    
    // matrix logic from http:.//stackoverflow.com/questions/2799755/rotate-array-clockwise
    
    func rotateLeft(map: [[Int]], playerPosition: CGPoint) -> (map: [[Int]], x: Int, y: Int){
        // duplicate the map
        var happyMap: [[Int]] = []
        for list in map {
            happyMap.append(list)
        }
        
        // int version of position
        var playerX = Int(playerPosition.x)
        var playerY = Int(playerPosition.y)
        
        // terrible wallhacks - calling copy pasted code 3 times
        
        // note dimensions of map
        let M = happyMap.count
        let N = happyMap[0].count
        
        // make another 2d Int array || MMM
        var ret = [[Int]]()
        
        // populate with zeroes
        for _ in 1...M {
            ret.append([Int](count: N, repeatedValue: 0))
        }
        
        // assign rotated state
        for r in 0...M-1 {
            for c in 0...N-1 {
                // reverse rows and columns
                ret[N-1-c][r] = happyMap[r][c]
            }
        }
        
        // put ret as Block back in happyMap || CCC
        for(i, list) in ret.enumerate() {
            for(j, block) in list.enumerate() {
                happyMap[i][j] = block
            }
        }
        let x = playerX
        let y = playerY
        playerX = y
        playerY = 3 - x
        
        return (happyMap, playerX, playerY)
    }
    
    func rotateRight(map: [[Int]], playerPosition: CGPoint) -> (map: [[Int]], x: Int, y: Int){
        var happyMap: [[Int]] = []
        for list in map {
            happyMap.append(list)
        }
        var playerX = Int(playerPosition.x)
        var playerY = Int(playerPosition.y)
        
        let M = map.count
        let N = map[0].count
        
        // print(M)
        //print(N)
        var ret = [[Int]]()
        for _ in 1...M {
            ret.append([Int](count: N, repeatedValue: 0))
        }
        for r in 0...M-1 {
            for c in 0...N-1 {
                //print(M-1-r)
                ret[c][M-1-r] = happyMap[r][c];
            }
        }
        for(i, list) in ret.enumerate() {
            for(j, block) in list.enumerate() {
                happyMap[i][j] = block
            }
        }
        let x = playerX
        let y = playerY
        playerX = 3 - y
        playerY = x
        
        
        return (happyMap, playerX, playerY)
    }
    
    func moveUpLeft(map: [[Int]], playerPosition: CGPoint) -> (map: [[Int]], x: Int, y: Int){
        var playerX = Int(playerPosition.x)
        var playerY = Int(playerPosition.y)
        playerY -= 1
        playerX -= 1
        return (map, playerX, playerY)
    }
    
    func moveUpRight(map: [[Int]], playerPosition: CGPoint) -> (map: [[Int]], x: Int, y: Int){
        var playerX = Int(playerPosition.x)
        var playerY = Int(playerPosition.y)
        playerY -= 1
        playerX += 1
        return (map, playerX, playerY)
    }
    
    
}