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
    var blockSize = 50
    var player = SKSpriteNode(imageNamed: "playerCircle.png")
    var playerX = 0
    var playerY = 2
    var level = 0
    var offsetX = 150
    var offsetY = 150
    
    override func didMoveToView(view: SKView) {
       
        loadLevels()
        drawLevel()
        player.position.x = CGFloat(playerX*blockSize + offsetX)
        player.position.y = CGFloat(playerY*blockSize + offsetY)
        player.zPosition = 10
        addChild(player)
    }
    
    func loadLevels() {
        
        let level1 = [[Block(id: 0), Block(id: 1), Block(id: 1)],
                      [Block(id: 1), Block(id: 1), Block(id: 0)],
                      [Block(id: 1), Block(id: 1), Block(id: 1)]]
        
        levels.append(level1)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        while(gravity()) { }

    }
    
    func gravity() -> Bool {
        var f = false
        for(i, list) in levels[level].dropLast().enumerate() {
            for(j, block) in list.enumerate() {
                if levels[level][i+1][j].id == 0 && block.affectedByGravity == true && block.id != 0 {
                    block.sprite.removeFromParent()
                    
                    block.sprite.position.y -= CGFloat(blockSize)
                    levels[level][i+1][j].sprite.position.y += CGFloat(blockSize)
                    levels[level][i][j] = levels[level][i+1][j]
                    levels[level][i+1][j] = block
                    addChild(block.sprite)
                    f = true
                }
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
}
