//
//  LevelSelect.swift
//  GravityPuzzle
//
//  Created by Casey Manning on 7/14/16.
//  Copyright © 2016 Casey Manning. All rights reserved.
//

import Foundation
import SpriteKit

class LevelSelect: SKScene {
    
    
    
    var levels: [MSButtonNode]!
    
    var numLevels = 35
    var l = 0
    var initialTouchLocation = CGPoint()
    
    override func didMoveToView(view: SKView) {
        let f: MSButtonNode = childNodeWithName("level1") as! MSButtonNode
        levels = [MSButtonNode](count: numLevels, repeatedValue: f)
        loadLevels()
    }
    
    func loadLevels() {
        
        for i in 0...numLevels - 1 {
            levels[i] = childNodeWithName("level\(i)") as! MSButtonNode
        }
        
        for (i,level) in levels.enumerate() {
            
            level.selectedHandler = {
                let skView = self.view as SKView!
                let scene = GameScene(fileNamed:"GameScene")!
                scene.scaleMode = .AspectFill
                skView.presentScene(scene, transition:SKTransition.crossFadeWithDuration(1))
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            initialTouchLocation = touch.locationInNode(self)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if touch.locationInNode(self).x > initialTouchLocation.x {
                camera?.position.x -= 5
            }
            if touch.locationInNode(self).x < initialTouchLocation.x {
                camera?.position.x += 5
            }

            if touch.locationInNode(self).y > initialTouchLocation.y {
                camera?.position.y -= 5
            }

            if touch.locationInNode(self).y < initialTouchLocation.y {
                camera?.position.y += 5
            }

        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
    }
}
