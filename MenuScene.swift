//
//  GameScene.swift
//  MightyQuest
//
//  Created by Casey Manning on 7/11/16.
//  Copyright (c) 2016 Casey Manning. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var playButton: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        
        playButton = childNodeWithName("playButton") as! MSButtonNode
        
        playButton.selectedHandler = {
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for _ in touches {
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for _ in touches {
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
