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
        var f: MSButtonNode = childNodeWithName("level1") as! MSButtonNode
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
                scene.level = i
                skView.presentScene(scene)
            }
        }
    }
}
