
//
//  Credits.swift
//  GravityPuzzle
//
//  Created by Casey Manning on 7/28/16.
//  Copyright © 2016 Casey Manning. All rights reserved.
//

import Foundation
import SpriteKit

class Credits: SKScene {
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        print("Credits seen")
//        
        let sequence = SKAction.sequence([SKAction.waitForDuration(5), SKAction.runBlock({ () -> Void in
        let skView = self.view
        let scene = MenuScene(fileNamed:"MenuScene")!
        scene.scaleMode = .AspectFill
        skView!.presentScene(scene, transition: SKTransition.crossFadeWithDuration(5))
        })])
        runAction(sequence)
    }
}
