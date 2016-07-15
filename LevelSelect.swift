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
        for (_,level) in levels.enumerate() {
            
            level.selectedHandler = {
                
            }
        }
    }
}
