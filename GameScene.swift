//
//  GameScene.swift
//  GravityPuzzle
//
//  Created by Casey Manning on 7/12/16.
//  Copyright (c) 2016 Casey Manning. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var levels = [[[Block]]]()
    var blockSize = 73
    var player = SKSpriteNode(imageNamed: "playerCircle.png")
    var playerX = 1
    var playerY = 2
    var level = 0
    var offsetX = 180
    var offsetY = 50
    var initialTouchLocation = CGPoint(x: 0, y: 0)
    var switchLeft: MSButtonNode!
    var switchRight: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        switchLeft = childNodeWithName("left") as! MSButtonNode
        switchRight = childNodeWithName("right") as! MSButtonNode
        loadLevels()
        drawLevel()
        player.position.x = CGFloat(playerX*blockSize + offsetX)
        player.position.y = CGFloat(playerY*blockSize + offsetY)
        player.position.y -= 72
        player.zPosition = 10
        
        addChild(player)
        
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
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("X is \(playerX), Y is \(playerY)")
        for touch in touches {
            movePlayer(touch)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        while(gravity()){}
        
        
        if won() {
            sleep(1)
            let skView = self.view as SKView!
            let scene = BetweenScene(fileNamed:"BetweenScene")!
            scene.scaleMode = .AspectFill
           // skView.presentScene(scene)
            scene.level = self.level
        }
    }
    
    func gravity() -> Bool {
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
                    addChild(block.sprite)
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
                addChild(block.sprite)
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
        
        for(_, list) in levels[level].enumerate() {
            for(_, block) in list.enumerate() {
                block.sprite.removeFromParent()
            }
        }

        
        if !left {
            
            let M = levels[level].count
            let N = levels[level][0].count
            print(M)
            print(N)
            var ret = [[Int]]()
            ret.append([Int](count: N, repeatedValue: 0))
            ret.append([Int](count: N, repeatedValue: 0))
            ret.append([Int](count: N, repeatedValue: 0))
            ret.append([Int](count: N, repeatedValue: 0))
            for r in 0...M-1 {
                for c in 0...N-1 {
                    print(M-1-r)
                    ret[c][M-1-r] = levels[level][r][c].id;
                }
            }
            
            for(i, list) in ret.enumerate() {
                for(j, block) in list.enumerate() {
                    levels[level][i][j] = Block(id:block)
                }
            }
            
        } else {
            for _ in 1...3 {
                
                let M = levels[level].count
                let N = levels[level][0].count
                print(M)
                print(N)
                var ret = [[Int]]()
                ret.append([Int](count: N, repeatedValue: 0))
                ret.append([Int](count: N, repeatedValue: 0))
                ret.append([Int](count: N, repeatedValue: 0))
                ret.append([Int](count: N, repeatedValue: 0))
                for r in 0...M-1 {
                    for c in 0...N-1 {
                        print(M-1-r)
                        ret[c][M-1-r] = levels[level][r][c].id;
                    }
                }
                
                for(i, list) in ret.enumerate() {
                    for(j, block) in list.enumerate() {
                        levels[level][i][j] = Block(id:block)
                    }
                }
            }
            
        }
        
        drawLevel()

    }
}


