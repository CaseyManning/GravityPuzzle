//
//  GameScene.swift
//  GravityPuzzle
//
//  Created by Casey Manning on 7/12/16.
//  Copyright (c) 2016 Casey Manning. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene {
    
    var levels = [[[Block]]]()
    var blockSize = 73
    var player = SKSpriteNode(imageNamed: "playerCircle.png")
    var playerX = 0
    var playerY = 1
    var level = 0
    var offsetX = 0
    var offsetY = 0
    var initialTouchLocation = CGPoint(x: 0, y: 0)
    var switchLeft: MSButtonNode!
    var switchRight: MSButtonNode!
    var levelNode: SKNode!
    var π = 3.141592
    var gameDone = false
    var dead = false
    var restart: MSButtonNode!
    var winned = false
    
    var random = true
    
    
    override func didMoveToView(view: SKView) {
        offsetX = -blockSize*2 + 36
        offsetY = -blockSize*2 + 36
        displayHint()
        restart = childNodeWithName("restart") as! MSButtonNode
        switchLeft = childNodeWithName("left") as! MSButtonNode
        switchRight = childNodeWithName("right") as! MSButtonNode
        levelNode = childNodeWithName("levelNode")!
        loadLevels()
        for _ in -1...level {
            levels.append([])
        }
        if random {
            levels[level] = LevelGenerator(scene: self).generateNewLevel()
        }
        drawLevel()
        drawPlayer()
        player.zPosition = 10
        
        restart.selectedHandler = {
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene")!
            scene.scaleMode = .AspectFill
            scene.level = self.level
            skView.presentScene(scene)
            
        }
        
        levelNode.addChild(player)
        
        switchLeft.selectedHandler = {self.switchGravity(true)}
        switchRight.selectedHandler = {self.switchGravity(false)}
        
        if !random {
        if level < 4 {
            switchRight.state = .Hidden
        }
    
        if level < 5 {
            switchLeft.state = .Hidden
        }
        }
    }
    
    func loadLevels() {
        
        let level0 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 2)]]
        
        let level1 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 2)]]
        
        let level2 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                      [Block(id: 1), Block(id: 1), Block(id: 2), Block(id: 1)]]
        
        let level3 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 2)],
                      [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 1)],
                      [Block(id: 1), Block(id: 1), Block(id: 1), Block(id: 1)]]

        
        let level4 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 2)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 1)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 1)]]
        
        let level5 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 1)],
                      [Block(id: 1), Block(id: 1), Block(id: 2), Block(id: 1)]]
        
        let level6 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 3), Block(id: 0), Block(id: 0)],
                      [Block(id: 1), Block(id: 1), Block(id: 1), Block(id: 3)]]
        
         let level7 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 3)],
                       [Block(id: 1), Block(id: 0), Block(id: 3), Block(id: 1)]]

        let level8 = [[Block(id: 0), Block(id: 4), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 3), Block(id: 1), Block(id: 3)]]
        
        let level9 = [[Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 2)]]
        
        let level10 = [[Block(id: 4), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 1)],
                       [Block(id: 1), Block(id: 0), Block(id: 1), Block(id: 2)]]
 
        let level11 = [[Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 2)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 1)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 1)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 1)]]
        
        let level13 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 2)]]
        
                let level12 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                               [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 1)],
                               [Block(id: 1), Block(id: 1), Block(id: 2), Block(id: 1)]]
        
                let level14 = [[Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 0)],
                               [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 4)],
                               [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 0)],
                               [Block(id: 1), Block(id: 0), Block(id: 2), Block(id: 0)]]
        
                let level15 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 1)],
                               [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 3)],
                               [Block(id: 0), Block(id: 1), Block(id: 3), Block(id: 1)]]
        
                let level16 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 1)],
                               [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 2)]]
        
                let level17 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                               [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 2)],
                               [Block(id: 1), Block(id: 0), Block(id: 1), Block(id: 1)]]

                let level18 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                               [Block(id: 1), Block(id: 1), Block(id: 1), Block(id: 0)],
                               [Block(id: 1), Block(id: 2), Block(id: 4), Block(id: 0)]]
        
                let level19 = [[Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 1)],
                               [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 3)],
                               [Block(id: 0), Block(id: 3), Block(id: 0), Block(id: 4)],
                               [Block(id: 1), Block(id: 1), Block(id: 1), Block(id: 0)]]
        
       /*need*/ let level20 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 0), Block(id: 2), Block(id: 0)]]

                let level21 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 3)],
                               [Block(id: 1), Block(id: 0), Block(id: 3), Block(id: 1)]]
        
                let level22 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 3)],
                               [Block(id: 1), Block(id: 0), Block(id: 3), Block(id: 1)]]

        
        let level23 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 3)],
                       [Block(id: 1), Block(id: 0), Block(id: 3), Block(id: 1)]]






        

        //levels.append(LevelGenerator(scene: self).generateNewLevel())
        levels.append(level0)
        levels.append(level1)
        levels.append(level2)
        levels.append(level3)
        levels.append(level4)
        levels.append(level5)
        levels.append(level6)
        levels.append(level7)
        levels.append(level8)
        levels.append(level9)
        levels.append(level10)
        levels.append(level11)
        levels.append(level12)
        levels.append(level13)
        levels.append(level14)
        levels.append(level15)
        levels.append(level16)
        levels.append(level17)
        levels.append(level18)
        levels.append(level19)
        levels.append(level20)
        levels.append(level21)
        levels.append(level22)
        levels.append(level23)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
        for touch in touches {
            initialTouchLocation = touch.locationInNode(self)
        }
    }
    
    func restartLevel() {
        if dead {return}
        dead = true
        sleep(1)
        let skView = self.view as SKView!
        let scene = BetweenScene(fileNamed:"BetweenScene")!
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        scene.level = self.level

    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //print("X is \(playerX), Y is \(playerY)")
        for touch in touches {
            movePlayer(touch)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        while(gravity()){}
        playerDead()
        
        if won(levels[level], x: playerX, y: playerY) && winned == false{
            winned = true
            let sequence = SKAction.sequence([SKAction.waitForDuration(1), SKAction.runBlock({ () -> Void in
            print("You Win")
            let skView = self.view as SKView!
            let scene = BetweenScene(fileNamed:"BetweenScene")!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            scene.level = self.level
            })])
            runAction(sequence)
            }
    
    }
    
    func gravity() -> Bool {
         //print("X is \(playerX), Y is \(playerY)")
        var f = false
        for(i, list) in levels[level].dropLast().enumerate() {
            for(j, block) in list.enumerate() {
                if levels[level][i+1][j].id == 0 && block.affectedByGravity == true && block.id != 0 {
                    
                    //block.sprite.position.y -= CGFloat(blockSize)
                    //block.sprite.runAction(SKAction(named: "moveDown")
                    block.sprite.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -blockSize), duration: 0.30))
                    levels[level][i+1][j].sprite.position.y += CGFloat(blockSize)
                    levels[level][i][j] = levels[level][i+1][j]
                    levels[level][i+1][j] = block
                    f = true
                }
            }
        }
        
        if playerY < 3 {
            if levels[level][playerY + 1][playerX].id == 0 {
                player.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -blockSize), duration: 0.30))
                playerY += 1
            }
        }
        
        return f
    }
    
    func drawLevel() {
        for(i, list) in levels[level].reverse().enumerate() {
            for(j, block) in list.enumerate() {
                
                block.sprite.position = CGPoint(x: j*blockSize, y: i*blockSize)
                block.sprite.position.x += CGFloat(offsetX)
                block.sprite.position.y += CGFloat(offsetY)
                levelNode.addChild(block.sprite)
            }
        }
    }
    
    func movePlayer(touch: UITouch) {
        
        if touch.locationInNode(self).y > initialTouchLocation.y + 100 && playerY > 0 && levels[level][playerY-1][playerX].id == 0 {
            player.runAction(SKAction.moveBy(CGVector(dx: 0, dy: blockSize), duration: 0.15))
            playerY -= 1
        }

        
        if touch.locationInNode(self).x > initialTouchLocation.x + 50 && playerX < 3 {
            //print(levels[level][playerY][playerX+1].id)
            if levels[level][playerY][playerX+1].id == 0 {
                player.runAction(SKAction.moveBy(CGVector(dx: blockSize, dy: 0), duration: 0.10))
                playerX += 1
            } else if playerX < 2 {
                if levels[level][playerY][playerX+2].id == 0 {
                    player.runAction(SKAction.moveBy(CGVector(dx: blockSize, dy: 0), duration: 0.10))
                    
                    levels[level][playerY][playerX+1].sprite.runAction(SKAction.moveBy(CGVector(dx: blockSize, dy: 0), duration: 0.07))
                    levels[level][playerY][playerX+2].sprite.runAction(SKAction.moveBy(CGVector(dx: -blockSize, dy: 0), duration: 0.02))
                    let b = Block(id: levels[level][playerY][playerX+2].id)
                    levels[level][playerY][playerX+2] = levels[level][playerY][playerX+1]
                    levels[level][playerY][playerX+1] = b
                    playerX += 1
                    
                }
            }
        }
        
        if touch.locationInNode(self).x < initialTouchLocation.x - 50 && playerX > 0 {
            print(levels[level][playerY][playerX-1].id)
            if levels[level][playerY][playerX-1].id == 0 {
                player.runAction(SKAction.moveBy(CGVector(dx: -blockSize, dy: 0), duration: 0.10))
                playerX -= 1
            } else if playerX > 1 {
                if levels[level][playerY][playerX-2].id == 0 {
                    player.runAction(SKAction.moveBy(CGVector(dx: -blockSize, dy: 0), duration: 0.10))
                    
                    levels[level][playerY][playerX-1].sprite.runAction(SKAction.moveBy(CGVector(dx: -blockSize, dy: 0), duration: 0.07))
                    levels[level][playerY][playerX-2].sprite.runAction(SKAction.moveBy(CGVector(dx: blockSize, dy: 0), duration: 0.02))
                    let b = Block(id: levels[level][playerY][playerX-2].id)
                    levels[level][playerY][playerX-2] = levels[level][playerY][playerX-1]
                    levels[level][playerY][playerX-1] = b
                    playerX -= 1
                    
                }
            }
        }
        
        
    }
    
    func won(map: [[Block]], x: Int, y: Int) -> Bool {
        
        if(x > 0 && map[y][x-1].id == 2) {
            return true
        }
        if(x < 3 && map[y][x+1].id == 2) {
            return true
        }
        if(y > 0 && map[y-1][x].id == 2) {
            return true
        }
        if(y < 3 && map[y+1][x].id == 2) {
            return true
        }
        for(i, list) in map.enumerate() {
            for(j, block) in list.enumerate() {
                if block.id == 3 {
                    if i > 0 && map[i-1][j].id == 3 {
                        return true
                    }
                    if i < 3 && map[i+1][j].id == 3 {
                        return true
                    }
                    if j > 0 && map[i][j-1].id == 3 {
                        return true
                    }
                    if j < 3 && map[i][j+1].id == 3 {
                        return true
                    }
                }
            }
        }
        
        return false
    }

    func won(map: [[Int]], x: Int, y: Int) -> Bool {
        
        if(x > 0 && map[y][x-1] == 2) {
            return true
        }
        if(x < 3 && map[y][x+1] == 2) {
            return true
        }
        if(y > 0 && map[y-1][x] == 2) {
            return true
        }
        if(y < 3 && map[y+1][x] == 2) {
            return true
        }
        for(i, list) in map.enumerate() {
            for(j, block) in list.enumerate() {
                if block == 3 {
                    if i > 0 && map[i-1][j] == 3 {
                        return true
                    }
                    if i < 3 && map[i+1][j] == 3 {
                        return true
                    }
                    if j > 0 && map[i][j-1] == 3 {
                        return true
                    }
                    if j < 3 && map[i][j+1] == 3 {
                        return true
                    }
                }
            }
        }
        
        return false
    }

    
    func switchGravity(left: Bool) {
        print("Happy Time X is \(playerX), Y is \(playerY)")
         if left {
            let action = SKAction.rotateByAngle(CGFloat(π/2), duration: 0.6)
            let reset = SKAction.rotateByAngle(CGFloat(-self.π/2), duration: 0)
            let sequence = SKAction.sequence([action, reset, SKAction.runBlock({ () -> Void in
                    
                    let M = self.levels[self.level].count
                    let N = self.levels[self.level][0].count
                    
                    
                    for(_, list) in self.levels[self.level].enumerate() {
                        for(_, block) in list.enumerate() {
                            block.sprite.removeFromParent()
                        }
                    }

                    //print(M)
                    //print(N)
                    var ret = [[Int]]()
                    ret.append([Int](count: N, repeatedValue: 0))
                    ret.append([Int](count: N, repeatedValue: 0))
                    ret.append([Int](count: N, repeatedValue: 0))
                    ret.append([Int](count: N, repeatedValue: 0))
                    for r in 0...M-1 {
                        for c in 0...N-1 {
                            //print(M-1-r)
                            ret[N-1-c][r] = self.levels[self.level][r][c].id
                        }
                    }
                    
                    for(i, list) in ret.enumerate() {
                        for(j, block) in list.enumerate() {
                            self.levels[self.level][i][j] = Block(id:block)
                        }
                    }
                let x = self.playerX
                let y = self.playerY
                self.playerX = y
                self.playerY = 3 - x
                //self.levelNode.runAction(SKAction.rotateByAngle(CGFloat(-self.π/2), duration: 0))
                self.drawLevel()
                self.drawPlayer()

            })])
             levelNode.runAction(sequence)
        } else {
            let reset = SKAction.rotateByAngle(CGFloat(self.π/2), duration: 0)
             let action = SKAction.rotateByAngle(CGFloat(-π/2), duration: 0.6)
             let sequence = SKAction.sequence([action, reset, SKAction.runBlock({ () -> Void in
                let M = self.levels[self.level].count
                let N = self.levels[self.level][0].count
                
                for(_, list) in self.levels[self.level].enumerate() {
                    for(_, block) in list.enumerate() {
                        block.sprite.removeFromParent()
                    }
                }
                
                // print(M)
                //print(N)
                var ret = [[Int]]()
                ret.append([Int](count: N, repeatedValue: 0))
                ret.append([Int](count: N, repeatedValue: 0))
                ret.append([Int](count: N, repeatedValue: 0))
                ret.append([Int](count: N, repeatedValue: 0))
                for r in 0...M-1 {
                    for c in 0...N-1 {
                        //print(M-1-r)
                        ret[c][M-1-r] = self.levels[self.level][r][c].id;
                    }
                }
                
                for(i, list) in ret.enumerate() {
                    for(j, block) in list.enumerate() {
                        self.levels[self.level][i][j] = Block(id:block)
                    }
                }
                
                let x = self.playerX
                let y = self.playerY
                self.playerX = 3 - y
                self.playerY = x
                self.drawLevel()
                self.drawPlayer()
            })])
            levelNode.runAction(sequence)
        
        }
        
        
        print("rgiu X is \(playerX), Y is \(playerY)")

    }
    
    func playerDead() {
        if !dead {
        if levels[level][playerY][playerX].id != 0 {
            dead = true
            let sequence = SKAction.sequence([SKAction.waitForDuration(0.3), SKAction.runBlock({ () -> Void in
                print("You Lose")
                let skView = self.view as SKView!
                let scene = GameScene(fileNamed:"GameScene")!
                scene.scaleMode = .AspectFill
                scene.level = self.level
                skView.presentScene(scene)
                
            })])
            runAction(sequence)
        }
        }
    }
    
    func drawPlayer() {
        //print("\n\nbefore it all falls apart \(player.position) x\(playerX)y\(playerY)")
        player.position.x = CGFloat(playerX*blockSize + offsetX)
        // logical height of game
        let logicalHeight = 3 * blockSize + offsetY
        // don't disalign reality
        player.position.y = CGFloat(logicalHeight - playerY*blockSize)
        //print("after it is all thoroughly broken \(player.position)")
    }
    
    func displayHint() {
        if level == 6 {
            let hint = SKSpriteNode(imageNamed: "hint.png")
            hint.alpha = 0
            hint.position = CGPoint(x: 275, y: 255)
            hint.zPosition = 5
            addChild(hint)
            hint.runAction(SKAction(named: "Fade")!)
        }

        if level == 5 {
            let hint = SKSpriteNode(imageNamed: "hint2.png")
            hint.position = CGPoint(x: 275, y: 255)
            hint.zPosition = 5
            hint.alpha = 0
            addChild(hint)
            hint.runAction(SKAction(named: "Fade")!)
        }

        
        if level == 0 {
            let hint = SKSpriteNode(imageNamed: "hint1.png")
            hint.position = CGPoint(x: 275, y: 255)
            hint.zPosition = 5
            hint.alpha = 0
            addChild(hint)
            hint.runAction(SKAction(named: "Fade")!)
        }
    }
    
    
}


