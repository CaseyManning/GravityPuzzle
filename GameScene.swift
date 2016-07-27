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
    
    var lvvvls = [[[Block]]]()
    var blockSize = 73
    var player = SKSpriteNode(imageNamed: "idle1.png")
    var playerX = 0
    var playerY = 1
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
    var direction = -1
    var levelLabel: SKLabelNode!
    var bLeft: SKSpriteNode!
    var bRight: SKSpriteNode!
    var turning = false
    var random = false
    var backdrop: SKSpriteNode!
    var playerUp = 0
    var mapSize = 4
    
    let gameManager = GameManager.sharedInstance
    
    override func didMoveToView(view: SKView) {
        offsetX = -blockSize*2 + 36
        offsetY = -blockSize*2 + 36
        displayHint()
        player.xScale = 0.22*CGFloat(direction)
        player.yScale = 0.22
        player.runAction(SKAction(named: "Idle")!)
        
        levelLabel = childNodeWithName("level") as! SKLabelNode
        restart = childNodeWithName("restart") as! MSButtonNode
        switchLeft = childNodeWithName("left") as! MSButtonNode
        switchRight = childNodeWithName("right") as! MSButtonNode
        levelNode = childNodeWithName("levelNode")!
        bLeft = childNodeWithName("bLeft") as! SKSpriteNode
        bRight = childNodeWithName("bRight") as! SKSpriteNode
        backdrop = childNodeWithName("//backdrop") as! SKSpriteNode
        loadlvvvls()
        for _ in -1...gameManager.level {
            lvvvls.append([])
        }
        if random {
            lvvvls[gameManager.level] = LevelGenerator(scene: self).generateNewLevel()
        }
        drawLevel()
        drawPlayer()
        player.zPosition = 10
        levelLabel.text = String(gameManager.level)
        
        restart.selectedHandler = {
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene")!
            scene.scaleMode = .AspectFill
            scene.gameManager.level = self.gameManager.level
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            
        }
        
        levelNode.addChild(player)
        
        switchLeft.selectedHandler = {self.switchGravity(true)}
        switchRight.selectedHandler = {self.switchGravity(false)}
        
        if !random {
            if gameManager.level < 4 {
                switchRight.state = .Hidden
                bRight.alpha = 0
            }
            
            if gameManager.level < 5 {
                switchLeft.state = .Hidden
                bLeft.alpha = 0
            }
        }
    }
    
    func loadlvvvls() {
        
        let level0 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 2)]]
        
        let level1 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                      [Block(id: 1), Block(id: 1), Block(id: 2), Block(id: 1)]]
        
        let level2 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 2)],
                      [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 1)],
                      [Block(id: 1), Block(id: 1), Block(id: 1), Block(id: 1)]]
        
        let level3 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 0)],
                      [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 2)]]
        
        
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
                      [Block(id: 0), Block(id: 3), Block(id: 0), Block(id: 3)],
                      [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 1)]]
        
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
        
        let level12 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 3)],
                       [Block(id: 1), Block(id: 0), Block(id: 3), Block(id: 1)]]
        
        let level13 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 2)],
                       [Block(id: 1), Block(id: 0), Block(id: 1), Block(id: 1)]]
        
         let level14 = [[Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 0)],
                        [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 4)],
                        [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 0)],
                        [Block(id: 1), Block(id: 0), Block(id: 2), Block(id: 0)]]
    
        let level15 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 4)],
                       [Block(id: 1), Block(id: 2), Block(id: 1), Block(id: 0)]]
        
                let level16 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 1)],
                               [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 2)]]
        
                let level17 = [[Block(id: 0), Block(id: 0), Block(id: 3), Block(id: 4)],
                               [Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 0)],
                               [Block(id: 0), Block(id: 3), Block(id: 1), Block(id: 0)],
                               [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 1)]]
        
                let level18 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                               [Block(id: 1), Block(id: 1), Block(id: 1), Block(id: 0)],
                               [Block(id: 1), Block(id: 2), Block(id: 4), Block(id: 0)]]
        
                let level19 = [[Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 1)],
                               [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 3)],
                               [Block(id: 0), Block(id: 3), Block(id: 0), Block(id: 4)],
                               [Block(id: 1), Block(id: 1), Block(id: 1), Block(id: 0)]]
        
                let level20 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                               [Block(id: 0), Block(id: 3), Block(id: 1), Block(id: 0)],
                               [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 3)],
                               [Block(id: 1), Block(id: 0), Block(id: 1), Block(id: 1)]]
        
        let level21 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 1)],
                       [Block(id: 0), Block(id: 1), Block(id: 2), Block(id: 4)],
                       [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 0)]]
        
        let level22 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 1)],
                       [Block(id: 0), Block(id: 3), Block(id: 1), Block(id: 1)],
                       [Block(id: 3), Block(id: 1), Block(id: 1), Block(id: 1)]]
        
        let level23 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 3), Block(id: 4), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 3)],
                       [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 4)]]
        
        let level24 = [[Block(id: 0), Block(id: 3), Block(id: 0), Block(id: 4)],
                       [Block(id: 0), Block(id: 4), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 4)],
                       [Block(id: 1), Block(id: 3), Block(id: 1), Block(id: 0)]]

        let level25 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 0), Block(id: 1)],
                       [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 1)],
                       [Block(id: 1), Block(id: 0), Block(id: 2), Block(id: 1)]]
        
        let level29 = [[Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 1)],
                       [Block(id: 0), Block(id: 4), Block(id: 2), Block(id: 1)]]

        
        let level28 = [[Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 1)],
                       [Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 4)],
                       [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 0)],
                       [Block(id: 1), Block(id: 0), Block(id: 2), Block(id: 1)]]

        let level27 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 3)],
                       [Block(id: 0), Block(id: 4), Block(id: 3), Block(id: 4)],
                       [Block(id: 1), Block(id: 1), Block(id: 1), Block(id: 0)]]
        
        let level26 = [[Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 2)],
                       [Block(id: 0), Block(id: 1), Block(id: 4), Block(id: 4)]]
        
        let level30 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 3)],
                       [Block(id: 0), Block(id: 4), Block(id: 3), Block(id: 1)]]
        
        let level31 = [[Block(id: 0), Block(id: 0), Block(id: 2), Block(id: 4)],
                       [Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 0), Block(id: 0)],
                       [Block(id: 1), Block(id: 1), Block(id: 1), Block(id: 0)]]

        let level32 = [[Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 4), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 0), Block(id: 0)],
                       [Block(id: 1), Block(id: 0), Block(id: 2), Block(id: 1)]]

       /*knead*/ let level33 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 2), Block(id: 0), Block(id: 0)]]
        
        let level34 = [[Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 1), Block(id: 0)],
                       [Block(id: 0), Block(id: 3), Block(id: 3), Block(id: 4)],
                       [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 0)]]
        
        let level35 = [[Block(id: 0), Block(id: 3), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 3), Block(id: 0), Block(id: 0), Block(id: 1)]]
        
        let level36 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 4)],
                       [Block(id: 0), Block(id: 1), Block(id: 4), Block(id: 0)],
                       [Block(id: 0), Block(id: 1), Block(id: 1), Block(id: 3)],
                       [Block(id: 1), Block(id: 4), Block(id: 3), Block(id: 4)]]
        
        let level37 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 4)],
                       [Block(id: 0), Block(id: 4), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 0), Block(id: 3), Block(id: 1)],
                       [Block(id: 3), Block(id: 0), Block(id: 1), Block(id: 1)]]
        
        let level38 = [[Block(id: 0), Block(id: 0), Block(id: 4), Block(id: 4)],
                       [Block(id: 0), Block(id: 4), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 3), Block(id: 4)],
                       [Block(id: 1), Block(id: 0), Block(id: 1), Block(id: 3)]]
        
        
        let level39 = [[Block(id: 0), Block(id: 0), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 3), Block(id: 0), Block(id: 0)],
                       [Block(id: 0), Block(id: 4), Block(id: 1), Block(id: 1)],
                       [Block(id: 1), Block(id: 0), Block(id: 3), Block(id: 1)]]



       
        // 35: 6 moves - 5/10
        // 36: 6 moves - 6/10
        // 37: 3 moves - 4/10
        // 38: 7 moves - 7/10
        // 39: 15 moves - 9/10
        
        
        
        
        
        
        
        lvvvls.append(level0)
        lvvvls.append(level1)
        lvvvls.append(level2)
        lvvvls.append(level3)
        lvvvls.append(level4)
        lvvvls.append(level5)
        lvvvls.append(level6)
        lvvvls.append(level22)
        lvvvls.append(level8)
        lvvvls.append(level9)
        lvvvls.append(level10)
        lvvvls.append(level7)
        lvvvls.append(level26)
        lvvvls.append(level23)
        lvvvls.append(level12)
        lvvvls.append(level13)
        lvvvls.append(level14)
        lvvvls.append(level19)
        lvvvls.append(level20)
        lvvvls.append(level27)
        lvvvls.append(level37)
        lvvvls.append(level25)
        lvvvls.append(level16)
        lvvvls.append(level30)
        lvvvls.append(level21)
        lvvvls.append(level24)
        lvvvls.append(level35)
        lvvvls.append(level32)
        lvvvls.append(level29)
        lvvvls.append(level18)
        lvvvls.append(level36)
        lvvvls.append(level15)
        lvvvls.append(level17)
        lvvvls.append(level28)
        lvvvls.append(level39)
        
        
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
        
        if won(lvvvls[gameManager.level], x: playerX, y: playerY) && winned == false{
            winned = true
            let sequence = SKAction.sequence([SKAction.waitForDuration(1), SKAction.runBlock({ () -> Void in
            print("You Win")
            
            let skView = self.view as SKView!
            let scene = BetweenScene(fileNamed:"BetweenScene")!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            })])
            runAction(sequence)
            }
    
    }
    
    func gravity() -> Bool {
        playerDead()
         //print("X is \(playerX), Y is \(playerY)")
        var f = false
        for(i, list) in lvvvls[gameManager.level].dropLast().enumerate() {
            for(j, block) in list.enumerate() {
                if lvvvls[gameManager.level][i+1][j].id == 0 && block.affectedByGravity == true && block.id != 0 && block.id != 5 {
                    
                    //block.sprite.position.y -= CGFloat(blockSize)
                    //block.sprite.runAction(SKAction(named: "moveDown")
                    block.sprite.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -blockSize), duration: 0.30))
                    lvvvls[gameManager.level][i+1][j].sprite.position.y += CGFloat(blockSize)
                    lvvvls[gameManager.level][i][j] = lvvvls[gameManager.level][i+1][j]
                    lvvvls[gameManager.level][i+1][j] = block
                    f = true
                }
            }
        }
        for(i, list) in lvvvls[gameManager.level].enumerate() {
            for(j, block) in list.enumerate() {
                if block.id == 5 && i > 0 && lvvvls[gameManager.level][i-1][j].id == 0 {
                    print("Gravitying shtuff")
                    //block.sprite.position.y -= CGFloat(blockSize)
                    //block.sprite.runAction(SKAction(named: "moveDown")
                    block.sprite.runAction(SKAction.moveBy(CGVector(dx: 0, dy: blockSize), duration: 0.50))
                    if playerX == j && playerY == i-1 && playerY > 0 {
                        print("Moving player up")
                        print("Playerx is \(playerX), and playerY is \(playerY)")
                        if playerUp == 0 {
                            playerY -= 1
                            playerUp += 1
                            
                            let sequence = SKAction.sequence([SKAction.moveBy(CGVector(dx: 0, dy: blockSize), duration: 0.50), SKAction.runBlock({ () -> Void in
                                
                                self.playerUp -= 1
                            })])
                            player.runAction(sequence)
                        } else if playerUp == 1 {
                            playerY -= 1
                            playerUp += 1
                            player.removeAllActions()
                            let sequence = SKAction.sequence([SKAction.moveBy(CGVector(dx: 0, dy: blockSize*2), duration: 1), SKAction.runBlock({ () -> Void in
                                
                                self.playerUp -= 1
                            })])
                            player.runAction(sequence)
                        } else if playerUp == 2 {
                            playerY -= 1
                            playerUp += 1
                            player.removeAllActions()
                            let sequence = SKAction.sequence([SKAction.moveBy(CGVector(dx: 0, dy: blockSize*3), duration: 1.5), SKAction.runBlock({ () -> Void in
                                
                                self.playerUp -= 1
                            })])
                            player.runAction(sequence)
                        }
                    }
                    
                    lvvvls[gameManager.level][i-1][j].sprite.position.y -= CGFloat(blockSize)
                    lvvvls[gameManager.level][i][j] = lvvvls[gameManager.level][i-1][j]
                    lvvvls[gameManager.level][i-1][j] = block
                    f = true
                    playerDead()
                }
            }
        }
        
        if playerY < mapSize - 1 {
            if lvvvls[gameManager.level][playerY + 1][playerX].id == 0 && lvvvls[gameManager.level][playerY][playerX].id == 0 {
                print("DOWN DOWN DOWN Block id is \(lvvvls[gameManager.level][playerY + 1][playerX].id)")
                printOutPlayerMap(lvvvls[gameManager.level], player: CGPoint(x: playerX,y: playerY))
                player.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -blockSize), duration: 0.30))
                playerY += 1
            }
        }
        
        return f
    }
    
    func drawLevel() {
        for(i, list) in lvvvls[gameManager.level].reverse().enumerate() {
            for(j, block) in list.enumerate() {
                block.sprite.position = CGPoint(x: j*blockSize, y: i*blockSize)
                block.sprite.position.x += CGFloat(offsetX)
                block.sprite.position.y += CGFloat(offsetY)
                block.sprite.zPosition = 10
                levelNode.addChild(block.sprite)
            }
        }
    }
    
    func movePlayer(touch: UITouch) {
        if turning { return }
        if touch.locationInNode(self).y > initialTouchLocation.y + 50 && playerY > 0 && lvvvls[gameManager.level][playerY-1][playerX].id == 0 {
            player.runAction(SKAction.moveBy(CGVector(dx: 0, dy: blockSize), duration: 0.15))
            playerY -= 1
            direction = -1
            player.xScale = 0.22*CGFloat(direction)

        }

        
        if touch.locationInNode(self).x > initialTouchLocation.x + 40 && playerX < mapSize - 1 {
            //print(lvvvls[gameManager.level][playerY][playerX+1].id)
            if lvvvls[gameManager.level][playerY][playerX+1].id == 0 {
                player.runAction(SKAction.moveBy(CGVector(dx: blockSize, dy: 0), duration: 0.10))
                playerX += 1
                direction = -1
                player.xScale = 0.22*CGFloat(direction)
            } else if playerX < 2 {
               if lvvvls[gameManager.level][playerY][playerX+2].id == 0 && lvvvls[gameManager.level][playerY][playerX+1].id != 4{
                    player.runAction(SKAction.moveBy(CGVector(dx: blockSize, dy: 0), duration: 0.10))
                    
                    lvvvls[gameManager.level][playerY][playerX+1].sprite.runAction(SKAction.moveBy(CGVector(dx: blockSize, dy: 0), duration: 0.07))
                    lvvvls[gameManager.level][playerY][playerX+2].sprite.runAction(SKAction.moveBy(CGVector(dx: -blockSize, dy: 0), duration: 0.02))
                    let b = Block(id: lvvvls[gameManager.level][playerY][playerX+2].id)
                    lvvvls[gameManager.level][playerY][playerX+2] = lvvvls[gameManager.level][playerY][playerX+1]
                    lvvvls[gameManager.level][playerY][playerX+1] = b
                    playerX += 1
                direction = -1
                player.xScale = 0.22*CGFloat(direction)
                }
            }
        }
        
        if touch.locationInNode(self).x < initialTouchLocation.x - 40 && playerX > 0 {
            print(lvvvls[gameManager.level][playerY][playerX-1].id)
            if lvvvls[gameManager.level][playerY][playerX-1].id == 0 {
                player.runAction(SKAction.moveBy(CGVector(dx: -blockSize, dy: 0), duration: 0.10))
                playerX -= 1
                direction = 1
                player.xScale = 0.22*CGFloat(direction)

            } else if playerX > 1 {
               if lvvvls[gameManager.level][playerY][playerX-2].id == 0 && lvvvls[gameManager.level][playerY][playerX-1].id != 4{
                    player.runAction(SKAction.moveBy(CGVector(dx: -blockSize, dy: 0), duration: 0.10))
                    
                    lvvvls[gameManager.level][playerY][playerX-1].sprite.runAction(SKAction.moveBy(CGVector(dx: -blockSize, dy: 0), duration: 0.07))
                    lvvvls[gameManager.level][playerY][playerX-2].sprite.runAction(SKAction.moveBy(CGVector(dx: blockSize, dy: 0), duration: 0.02))
                    let b = Block(id: lvvvls[gameManager.level][playerY][playerX-2].id)
                    lvvvls[gameManager.level][playerY][playerX-2] = lvvvls[gameManager.level][playerY][playerX-1]
                    lvvvls[gameManager.level][playerY][playerX-1] = b
                    playerX -= 1
                    direction = 1
                    player.xScale = 0.22*CGFloat(direction)
                }
            }
        }
        
        
    }
    
    func won(map: [[Block]], x: Int, y: Int) -> Bool {
        
        if(x > 0 && map[y][x-1].id == 2) {
            return true
        }
        if(x < mapSize - 1 && map[y][x+1].id == 2) {
            return true
        }
        if(y > 0 && map[y-1][x].id == 2) {
            return true
        }
        if(y < mapSize - 1 && map[y+1][x].id == 2) {
            return true
        }
        for(i, list) in map.enumerate() {
            for(j, block) in list.enumerate() {
                if block.id == 3 {
                    if i > 0 && map[i-1][j].id == 3 {
                        return true
                    }
                    if i < mapSize - 1 && map[i+1][j].id == 3 {
                        return true
                    }
                    if j > 0 && map[i][j-1].id == 3 {
                        return true
                    }
                    if j < mapSize - 1 && map[i][j+1].id == 3 {
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
        if(x < mapSize - 1 && map[y][x+1] == 2) {
            return true
        }
        if(y > 0 && map[y-1][x] == 2) {
            return true
        }
        if(y < mapSize - 1 && map[y+1][x] == 2) {
            return true
        }
        for(i, list) in map.enumerate() {
            for(j, block) in list.enumerate() {
                if block == 3 {
                    if i > 0 && map[i-1][j] == 3 {
                        return true
                    }
                    if i < mapSize - 1 && map[i+1][j] == 3 {
                        return true
                    }
                    if j > 0 && map[i][j-1] == 3 {
                        return true
                    }
                    if j < mapSize - 1 && map[i][j+1] == 3 {
                        return true
                    }
                }
            }
        }
        
        return false
    }

    
    func switchGravity(left: Bool) {
        print("Happy Time X is \(playerX), Y is \(playerY)")
        if turning { return }
        turning = true
         if left {
            let action = SKAction.rotateByAngle(CGFloat(π/2), duration: 0.6)
            let reset = SKAction.rotateByAngle(CGFloat(-self.π/2), duration: 0)
            let sequence = SKAction.sequence([action, reset, SKAction.runBlock({ () -> Void in
                    
                    let M = self.lvvvls[self.gameManager.level].count
                    let N = self.lvvvls[self.gameManager.level][0].count
                    
                    
                    for(_, list) in self.lvvvls[self.gameManager.level].enumerate() {
                        for(_, block) in list.enumerate() {
                            block.sprite.removeFromParent()
                        }
                    }

                let re = SKAction.rotateByAngle(CGFloat(self.π/2), duration: 0)
                self.backdrop.runAction(re)

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
                            ret[N-1-c][r] = self.lvvvls[self.gameManager.level][r][c].id
                        }
                    }
                    
                    for(i, list) in ret.enumerate() {
                        for(j, block) in list.enumerate() {
                            self.lvvvls[self.gameManager.level][i][j] = Block(id:block)
                        }
                    }
                let x = self.playerX
                let y = self.playerY
                self.playerX = y
                self.playerY = self.mapSize - 1 - x
                //self.gameManager.levelNode.runAction(SKAction.rotateByAngle(CGFloat(-self.π/2), duration: 0))
                self.drawLevel()
                self.drawPlayer()
                self.turning = false
            })])
             levelNode.runAction(sequence)
        } else {
            let reset = SKAction.rotateByAngle(CGFloat(self.π/2), duration: 0)
             let action = SKAction.rotateByAngle(CGFloat(-π/2), duration: 0.6)
             let sequence = SKAction.sequence([action, reset, SKAction.runBlock({ () -> Void in
                let M = self.lvvvls[self.gameManager.level].count
                let N = self.lvvvls[self.gameManager.level][0].count
                
                for(_, list) in self.lvvvls[self.gameManager.level].enumerate() {
                    for(_, block) in list.enumerate() {
                        block.sprite.removeFromParent()
                    }
                }
                let re = SKAction.rotateByAngle(CGFloat(-self.π/2), duration: 0)
                self.backdrop.runAction(re)
                
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
                        ret[c][M-1-r] = self.lvvvls[self.gameManager.level][r][c].id;
                    }
                }
                
                for(i, list) in ret.enumerate() {
                    for(j, block) in list.enumerate() {
                        self.lvvvls[self.gameManager.level][i][j] = Block(id:block)
                    }
                }
                
                let x = self.playerX
                let y = self.playerY
                self.playerX = self.mapSize - 1 - y
                self.playerY = x
                self.drawLevel()
                self.drawPlayer()
                self.turning = false
            })])
            levelNode.runAction(sequence)
        
        }
        
        
        print("rgiu X is \(playerX), Y is \(playerY)")

    }
    
    func playerDead() {
        if !dead {
            if lvvvls[gameManager.level][playerY][playerX].id != 0 {
            dead = true
            print("The player may have died")
            let sequence = SKAction.sequence([SKAction.waitForDuration(0.6), SKAction.runBlock({ () -> Void in
                print("You Lose")
                let skView = self.view as SKView!
                let scene = GameScene(fileNamed:"GameScene")!
                scene.scaleMode = .AspectFill
                scene.gameManager.level = self.gameManager.level
                skView.presentScene(scene, transition:SKTransition.crossFadeWithDuration(1))
                
            })])
            runAction(sequence)
        }
        }
    }
    
    func drawPlayer() {
        //print("\n\nbefore it all falls apart \(player.position) x\(playerX)y\(playerY)")
        player.position.x = CGFloat(playerX*blockSize + offsetX)
        // logical height of game
        let logicalHeight = mapSize - 1 * blockSize + offsetY
        // don't disalign reality
        player.position.y = CGFloat(logicalHeight - playerY*blockSize + 285)
        //print("after it is all thoroughly broken \(player.position)")
    }
    
    func displayHint() {
        
        if gameManager.level == 0 {
            
            let hint = SKSpriteNode(imageNamed: "arrow-left.png")
            hint.xScale = -0.7
            hint.yScale = 0.7
            hint.position = CGPoint(x: 225, y: 155)
            hint.zPosition = 20
            hint.alpha = 0
            addChild(hint)
            hint.runAction(SKAction(named: "Slide")!)
        }
        
        if gameManager.level == 1 {
            
            let hint = SKSpriteNode(imageNamed: "arrow-left.png")
            hint.xScale = -0.6
            hint.yScale = 0.6
            hint.position = CGPoint(x: 275, y: 125)
            hint.zPosition = 20
            hint.alpha = 0
            addChild(hint)
            hint.runAction(SKAction(named: "Fade")!)
        }

        if gameManager.level == 2 {
            
            let hint = SKSpriteNode(imageNamed: "arrow-left.png")
            hint.xScale = -0.6
            hint.yScale = 0.6
            hint.zRotation = 1
            hint.position = CGPoint(x: 325, y: 175)
            hint.zPosition = 20
            hint.alpha = 0
            addChild(hint)
            hint.runAction(SKAction(named: "Fade")!)
        }
        if gameManager.level == 3 {
            
            let hint = SKSpriteNode(imageNamed: "arrow-left.png")
            hint.xScale = -0.6
            hint.yScale = 0.6
            hint.zRotation = 1
            hint.position = CGPoint(x: 175, y: 105)
            hint.zPosition = 20
            hint.alpha = 0
            addChild(hint)
            hint.runAction(SKAction(named: "Fade")!)
        }
        
        if gameManager.level == 4 {
            
            let hint = SKSpriteNode(imageNamed: "arrow-left.png")
            hint.xScale = -0.6
            hint.yScale = 0.6
            hint.position = CGPoint(x: 415, y: 175)
            hint.zPosition = 20
            hint.alpha = 0
            addChild(hint)
            hint.runAction(SKAction(named: "Fade")!)
            hint.runAction(SKAction(named: "BackForth")!)
        }
        
    }
    
    func printOutPlayerMap(map: [[Block]], player: CGPoint) {
        print()
        print("----")
        for (y, list) in map.enumerate() {
            var ln = ""
            for (x, value) in list.enumerate() {
                if Int(player.x) == x && Int(player.y) == y {
                    ln += "\(value.id)X "
                } else {
                    ln += "\(value.id), "
                }
            }
            print(ln)
        }
        print("----")
        //        print("PlAYER POSITION: \(player.x) \(player.y)")
        //        print("----")
        
        print()
    }
    
}


