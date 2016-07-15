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
    
    var numLevels = 10
    var l = 0
    
    override func didMoveToView(view: SKView) {
        
    }
    
    func loadLevels() {
        
        for i in 0...numLevels {
            levels[i] = childNodeWithName("button\(i)") as! MSButtonNode
        }
        
        for (i,level) in levels.enumerate() {
            
            level.selectedHandler = {
                let skView = self.view as SKView!
                let scene = GameScene(fileNamed:"GameScene")!
                scene.scaleMode = .AspectFill
                scene.level = i
                skView.presentScene(scene)
            }
        }
    }
}
