//
//  LevelGenerator.swift
//  GravityPuzzle
//
//  Created by Casey Manning on 7/15/16.
//  Copyright © 2016 Casey Manning. All rights reserved.
//

import Foundation
import SpriteKit

class LevelGenerator {
    
    //how many blocks there are
    var numBlocks = 7
    var g: GameScene
    var maxMoves = 7
    var mooves = 0
    var mapSize = 4
    
    // Initialize with existing scene
    init(scene: GameScene) {
        g = scene
    }
    
    func generateNewLevel() -> [[Block]] {
        
        // infinte loop
        var i = 0
        print("TESTING NEW MAP")
        while true {
            i+=1
            if i%50000 == 0 {
                print("Generated another 50,000 levels")
            }
            // create random Map
            var map: [[Int]] = randomMap()
            if isDecent(map) && playThroughLevel(map, playerPosition: CGPoint(x: 0, y: 1), numMoves: 0) {
                // break out of loop
                if checkMoves() {
                print("BEGINNING OF FUNCTION")
               // printOutMap(map)
                let a = gravity(map, x: 0, yy: 1)
                map = a.map
                
//                printOutMap(map)
                var retMap: [[Block]] = []
                for list in map {
                    var blockList: [Block] = []
                    for int in list {
                        blockList.append(Block(id: int))
                    }
                    retMap.append(blockList)
                }
                    
                // break out of loop
                print("Generated \(i) levels, and none of them were any good. \nWe might just need to give up and use the last one")
                printOutMap(map)
                    print("NUMMOVES - \(mooves)")
                return retMap
                }
            }
            
        }
        
    }
    
    func randomMap() -> [[Int]] {
        
        // Make new 2d array
        var ret = [[Int]]()
        // 2d zero array
        ret.append([0, 0, 0, 0])
        ret.append([0, 0, 0, 0])
        ret.append([0, 1, 0, 0])
        ret.append([3, 1, 1, 3])
        //print("---ORIGINAL MAP---")
        //printOutMap(ret)
        //print("------------------")
        for (i, list) in ret.enumerate() {
            for (j, _) in list.enumerate() {
                ret[i][j] = randomTile()
            }
        }
        
        return ret
    }
    
    func randomTile() -> Int {
        // Generate a kind of block randomly
        var a = Int(Double(arc4random())/Double(UInt32.max) * Double(numBlocks))
        if a == 5 {
            a = 0
        }
        if a == 6 {
            a = 1
        }
        if a == 7 || a == 8 {
            a = 6
        }
        return a
    }
    
    // recursively play through level
    func playThroughLevel(map: [[Int]], playerPosition: CGPoint, numMoves: Int) -> Bool {
        var playerPos = playerPosition
        var a = gravity(map, x: Int(playerPosition.x), yy: Int(playerPosition.y))
        playerPos.x = CGFloat(a.x)
        playerPos.y = CGFloat(a.y)
        
        // capped at 7
        var moves = numMoves
        
        if checkIfDead(a.map, playerPos: playerPos) {
            return false
        }
        
        // success state
        if(g.won(a.map, x: Int(playerPos.x), y: Int(playerPos.y))) {
            //print("SUCCESS STATE MAP")
            //printOutMap(a.map)
            mooves = numMoves
            return true
        }
        
        
        
        // escape if too deep
        if numMoves > maxMoves {
            return false
        }
        moves += 1
        
        // floodgates
        if canMoveLeft(a.map, playerPosition: playerPos) {
            let f = moveLeft(a.map, playerPosition: playerPos)
            if a.map[Int(f.y)][Int(f.x)] != 0 {
                return false
            }
            if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: moves) {
                print("left, player at:x\(f.x)y\(f.y)")
                //printOutPlayerMap(a.map, player: playerPos)
                return true
            }
            
        }
        if canMoveRight(a.map, playerPosition: playerPos) {
            let f = moveRight(a.map, playerPosition: playerPos)
            if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: moves) {
                print("right, player at:x\(f.x)y\(f.y)")
                return true
            }
            
        }
        if canRotateRight(a.map, playerPosition: playerPos) {
            let f = rotateRight(a.map, playerPosition: playerPos)
            if a.map[Int(f.y)][Int(f.x)] != 0 {
                return false
            }
            if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: moves) {
                //print("Before: x = \(playerPos.x), y = \(playerPos.y)")
                print("rotRight, player at:x\(f.x)y\(f.y)")
                if checkIfDead(a.map, playerPos: playerPos) {
                    return false
                }
                return true
            }
            
        }
        if canRotateLeft(a.map, playerPosition: playerPos) {
            let f = rotateLeft(a.map, playerPosition: playerPos)
            if a.map[Int(f.y)][Int(f.x)] != 0 {
                return false
            }
            if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: moves) {
                //print("Before: x = \(playerPos.x), y = \(playerPos.y)")
                print("rotLeft, player at:x\(f.x)y\(f.y)")
                if checkIfDead(a.map, playerPos: playerPos) {
                    return false
                }
                return true
            }
            
        }
        if canUpRight(a.map, playerPosition: playerPos) {
            let f = moveUpRight(a.map, playerPosition: playerPos)
            if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: numMoves) {
                print("upRight, player at:x\(f.x)y\(f.y)")
                return true
            }
            
        }
        if canUpLeft(a.map, playerPosition: playerPos) {
            let f = moveUpLeft(a.map, playerPosition: playerPos)
            if playThroughLevel(f.map, playerPosition: CGPoint(x: f.x, y: f.y), numMoves: numMoves) {
                print("upLeft, player at:x\(f.x)y\(f.y)")
                return true
            }
        }
        
        return false
    }
    
    func checkMoves() -> Bool {
        return mooves > 3
    }
    
    func isDecent(maap: [[Int]]) -> Bool {
        
        
        let a = gravity(maap, x: 0, yy: 1)
        
        //print("Before Gravity")
        //printOutMap(maap)
        //print("After Gravity")
        //printOutMap(a.map)
        var goals = 0
        var connects = 0
        for list in a.map {
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
        if g.won(a.map, x: 1, y: 1) {
            return false
        }
        
        if a.map[1][0] != 0 || a.map[0][0] != 0 || a.map[2][0] != 0{
            return false
        }
        
        return true
    }
    
    func canMoveLeft(map: [[Int]], playerPosition: CGPoint) -> Bool {
        if playerPosition.x < 1 {
            return false
        }
        if map[Int(playerPosition.y)][Int(playerPosition.x-1)] == 0 {
            return true
        }
        if playerPosition.x < 2 {
            return false
        }
        return map[Int(playerPosition.y)][Int(playerPosition.x-2)] == 0
    }
    
    func canMoveRight(map: [[Int]], playerPosition: CGPoint) -> Bool {
        if Int(playerPosition.x) > map[0].count - 2 {
            return false
        }
        
        if map[Int(playerPosition.y)][Int(playerPosition.x+1)] == 0 {
            return true
        }
        if Int(playerPosition.x) > map[0].count - 3 {
            return false
        }
        return map[Int(playerPosition.y)][Int(playerPosition.x+2)] == 0
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
    
    
    // matrix logic from http://stackoverflow.com/questions/2799755/rotate-array-clockwise
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
    
    //pretend that the comments from the previous method are in here too, its basically a copy
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
        //print("Before: x = \(x), y = \(y)")
        //print("After: x = \(playerX), y = \(playerY)")
        
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
    
    
   
    
    
    
    
    

    func gravity(map: [[Int]], x: Int, yy: Int) -> (map: [[Int]], x: Int, y: Int) {
        //print("Gravitee")
        var y = yy
        var ret = map
        var f = true
        //printOutMap(map)
        while f {
            f = false
            for(i, list) in ret.dropLast().enumerate() {
                for(j, block) in list.enumerate() {
                    if ret[i+1][j] == 0 && block != 4 && block != 0 {
                        //print("Gravitying on \(j), \(i)")
                        ret[i][j] = ret[i+1][j]
                        ret[i+1][j] = block
                        f = true
                    }
                }
            }
        }
        if y < map.count - 1 && map[y+1][x] == 0 {
            y += 1
        }
        return (ret, x, y)
    }
    
    
    
    
    
    
    
    
    
    
    func printOutMap(map: [[Int]]) {
        print()
        print("----")
        for list in map {
            var ln = ""
            for value in list {
                ln += "\(value), "
            }
            print(ln)
        }
        print("----")
        print()
    }
    
    func printOutPlayerMap(map: [[Int]], player: CGPoint) {
        print()
        print("----")
        for (y, list) in map.enumerate() {
            var ln = ""
            for (x, value) in list.enumerate() {
                if Int(player.x) == x && Int(player.y) == y {
                    ln += "*, "
                } else {
                ln += "\(value), "
                }
            }
            print(ln)
        }
        print("----")
//        print("PlAYER POSITION: \(player.x) \(player.y)")
//        print("----")
        
        print()
    }
    
    func checkIfDead(map: [[Int]], playerPos: CGPoint) -> Bool {
        
        for i in 1...map.count {
            for j in 1...map[0].count {
                if i < Int(playerPos.y) && j == Int(playerPos.x) {
                    return true
                }
            }
        }
        return false
        //return map[Int(playerPos.y)][Int(playerPos.x)] != 0
    }
}