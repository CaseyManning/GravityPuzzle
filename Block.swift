//
//  Block.swift
//  GravityPuzzle
//
//  Created by Casey Manning on 7/12/16.
//  Copyright © 2016 Casey Manning. All rights reserved.
//

import Foundation
import SpriteKit

class Block {
    
    var affectedByGravity = true
    var pushable = true
    var sprite: SKSpriteNode
    var id = 0
    
    init(id: Int) {
        sprite = SKSpriteNode(imageNamed: "\(id).png")
        self.id = id
        
        if id == 4 {
            affectedByGravity = false
        }
    }
}