//
//  BetweenScene.swift
//  GravityPuzzle
//
//  Created by Casey Manning on 7/13/16.
//  Copyright © 2016 Casey Manning. All rights reserved.
//

import Foundation
import SpriteKit

class BetweenScene: SKScene{
    
    var level = 0
    var button: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        button = childNodeWithName("nextLevel") as! MSButtonNode
        button.selectedHandler = {
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            self.level += 1
            scene.level = self.level
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
        }
    }
}