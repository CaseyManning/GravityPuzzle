//
//  LevelSelect.swift
//  GravityPuzzle
//
//  Created by Casey Manning on 7/14/16.
//  Copyright © 2016 Casey Manning. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class LevelSelect: SKScene {
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    var levels: [MSButtonNode]!
    
    var numLevels = 44
    var l = 0
    var initialTouchLocation = CGPoint()
    var touching = false
    var exit: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        let f: MSButtonNode = childNodeWithName("level1") as! MSButtonNode
        levels = [MSButtonNode](count: numLevels, repeatedValue: f)
        loadLevels()
        exit = childNodeWithName("exit") as! MSButtonNode
        exit.selectedHandler = {
            let flapSFX = SKAction.playSoundFileNamed("button", waitForCompletion: false)
            self.runAction(flapSFX)
            let skView = self.view as SKView!
            let scene = MenuScene(fileNamed:"MenuScene")!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            
        }
    }
    
    func loadLevels() {
        
        for i in 0...numLevels - 1 {
            levels[i] = childNodeWithName("lev\(i)") as! MSButtonNode
        }
        
        for (i,level) in levels.enumerate() {
            
            level.selectedHandler = {
                let flapSFX = SKAction.playSoundFileNamed("button", waitForCompletion: false)
                self.runAction(flapSFX)
                let skView = self.view as SKView!
                let scene = GameScene(fileNamed:"GameScene")!
                scene.gameManager.level = i
                scene.scaleMode = .AspectFill
                skView.presentScene(scene, transition:SKTransition.crossFadeWithDuration(1))
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            initialTouchLocation = touch.locationInNode(self)
        }
        touching = true
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("TOUCHESMOVED")
        for touch in touches {
        let loc = touch.locationInNode(self)
        //touch.location
        //let loc = touch.locationInView(view)
        print("InitialTouchLocation: \(initialTouchLocation)")
        print("CurrentTouchLocation: \(loc)")
        //camera?.physicsBody?.velocity.dx = (initialTouchLocation.x - loc.x)*3
        camera?.physicsBody?.velocity.dy = (initialTouchLocation.y - loc.y)*3
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = false
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if camera?.position.y > 250 {
            camera?.physicsBody?.velocity.dy = 0
            camera?.position.y -= 1
        }
        
        if camera?.position.y < -380 {
            camera?.physicsBody?.velocity.dy = 0
            camera?.position.y += 1
        }
        
        for _ in 1...5 {
        if camera?.physicsBody?.velocity.dy > 0 {
            camera?.physicsBody?.velocity.dy -= 1
        }
        if camera?.physicsBody?.velocity.dy < 0 {
            camera?.physicsBody?.velocity.dy += 1
        }
        if camera?.physicsBody?.velocity.dx > 0 {
            camera?.physicsBody?.velocity.dx -= 1
        }
        if camera?.physicsBody?.velocity.dx < 0 {
            camera?.physicsBody?.velocity.dx += 1
        }
        }
    }
}
