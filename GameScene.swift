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
    var playerX = 1
    var playerY = 2
    var level = 0
    var offsetX = -0
    var offsetY = 0
    var initialTouchLocation = CGPoint(x: 0, y: 0)
    var switchLeft: MSButtonNode!
    var switchRight: MSButtonNode!
    var levelNode: SKNode!
    var π = 3.141592
    var gameDone = false
    var dead = false
    
    
    override func didMoveToView(view: SKView) {
        offsetX = -blockSize*2 + 26
        offsetY = -blockSize*2 + 26
        

        switchLeft = childNodeWithName("left") as! MSButtonNode
        switchRight = childNodeWithName("right") as! MSButtonNode
        levelNode = childNodeWithName("levelNode")!
        loadLevels()
        drawLevel()
        drawPlayer()
        player.zPosition = 10
        
        levelNode.addChild(player)
        
        switchLeft.selectedHandler = {self.switchGravity(true)}
        switchRight.selectedHandler = {self.switchGravity(false)}
    }
    
    func loadLevels() {
        
        let level1 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                      [Block(id: 1), Block(id: 1), Block(id: 2), Block(id: 1)]]
        
        let level2 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 1)],
                      [Block(id: 1), Block(id: 1), Block(id: 2), Block(id: 1)]]
        
        let level3 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 1)],
                      [Block(id: 1), Block(id: 1), Block(id: 2), Block(id: 1)]]

        levels.append(level1)
        levels.append(level2)
        levels.append(level3)
        
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
        print("X is \(playerX), Y is \(playerY)")
        for touch in touches {
            movePlayer(touch)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        while(gravity()){}
        
        
        if won() {
            print("You Win")
            print(random())
            if random() < 10000000 {
                let skView = self.view as SKView!
                let scene = BetweenScene(fileNamed:"BetweenScene")!
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                scene.level = self.level
            }
            
        }
    }
    
    func gravity() -> Bool {
         print("X is \(playerX), Y is \(playerY)")
        var f = false
        for(i, list) in levels[level].dropLast().enumerate() {
            for(j, block) in list.enumerate() {
                if levels[level][i+1][j].id == 0 && block.affectedByGravity == true && block.id != 0 {
                    block.sprite.removeFromParent()
                    
                    //block.sprite.position.y -= CGFloat(blockSize)
                    //block.sprite.runAction(SKAction(named: "moveDown")
                    block.sprite.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -blockSize), duration: 0.30))
                    levels[level][i+1][j].sprite.position.y += CGFloat(blockSize)
                    levels[level][i][j] = levels[level][i+1][j]
                    levels[level][i+1][j] = block
                    levelNode.addChild(block.sprite)
                    f = true
                }
            }
        }
        
        if playerY < 3 {
            print("disduuisiuifuih")
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
            print(levels[level][playerY][playerX+1].id)
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
    
    func won() -> Bool {
        
        if(playerX > 0 && levels[level][playerY][playerX-1].id == 2) {
            return true
        }
        if(playerX < 3 && levels[level][playerY][playerX+1].id == 2) {
            return true
        }
        if(playerY > 0 && levels[level][playerY-1][playerX].id == 2) {
            return true
        }
        if(playerY < 3 && levels[level][playerY+1][playerX].id == 2) {
            return true
        }
        
        return false
    }
    
    func switchGravity(left: Bool) {
        print("Happy Time X is \(playerX), Y is \(playerY)")

        for(_, list) in levels[level].enumerate() {
            for(_, block) in list.enumerate() {
               // block.sprite.removeFromParent()
            }
        }

        
        /*if !left {
            
            let M = levels[level].count
            let N = levels[level][0].count
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
                    ret[c][M-1-r] = levels[level][r][c].id;
                }
            }
            
            for(i, list) in ret.enumerate() {
                for(j, block) in list.enumerate() {
                    levels[level][i][j] = Block(id:block)
                }
            }
            
            let x = playerX
            let y = playerY
            playerX = 3 - y
            playerY = x
            
        } else {
            for _ in 1...3 {
                
                let M = levels[level].count
                let N = levels[level][0].count
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
                        ret[c][M-1-r] = levels[level][r][c].id;
                    }
                }
                
                for(i, list) in ret.enumerate() {
                    for(j, block) in list.enumerate() {
                        levels[level][i][j] = Block(id:block)
                    }
                }
            }
            let x = playerX
            let y = playerY
            playerX = y
            playerY = 3 - x
        }*/
        //player.removeFromParent()
        //levelNode.addChild(player)
         if left {
            let action = SKAction.rotateByAngle(CGFloat(π/2), duration: 1)
            let reset = SKAction.rotateByAngle(CGFloat(-self.π/2), duration: 0)
            let sequence = SKAction.sequence([action, reset, SKAction.runBlock({ () -> Void in
                for _ in 1...3 {
                    
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
                            ret[c][M-1-r] = self.levels[self.level][r][c].id;
                        }
                    }
                    
                    for(i, list) in ret.enumerate() {
                        for(j, block) in list.enumerate() {
                            self.levels[self.level][i][j] = Block(id:block)
                        }
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
             let action = SKAction.rotateByAngle(CGFloat(-π/2), duration: 1)
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
                //self.levelNode.runAction(SKAction.rotateByAngle(CGFloat(self.π/2), duration: 0))
            })])
            levelNode.runAction(sequence)
        
        }
        
        // this is getting called before the runblock finishes (threading issue)
        
        //drawLevel()
        //drawPlayer()
        
        print("rgiu X is \(playerX), Y is \(playerY)")

    }
    
    func drawPlayer() {
        print("\n\nbefore it all falls apart \(player.position) x\(playerX)y\(playerY)")
        player.position.x = CGFloat(playerX*blockSize + offsetX)
        // logical height of game
        let logicalHeight = 3 * blockSize + offsetY
        // don't disalign reality
        player.position.y = CGFloat(logicalHeight - playerY*blockSize)
        print("after it is all thoroughly broken \(player.position)")
    }
    
    
}


