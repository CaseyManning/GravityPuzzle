//
//  GameScene.swift
//  MightyQuest
//
//  Created by Casey Manning on 7/11/16.
//  Copyright (c) 2016 Casey Manning. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene {

    var playButton: MSButtonNode2!
    var levelSelect: MSButtonNode2!
    var creditsButton: MSButtonNode!
    var backgroundMusicPlayer = AVAudioPlayer()
    
    override func didMoveToView(view: SKView) {
        playBackgroundMusic("Spartan Opinion.mp3")
        playButton = childNodeWithName("playButton") as! MSButtonNode2
        playButton.link = childNodeWithName("foo") as! SKSpriteNode
        playButton.selectedHandler = {
            
            let flapSFX = SKAction.playSoundFileNamed("button", waitForCompletion: false)
            self.runAction(flapSFX)
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.backgroundMusicPlayer = self.backgroundMusicPlayer
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            
            /* Start game scene */
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
        }

        
        levelSelect = childNodeWithName("levelSelect") as! MSButtonNode2
        levelSelect.link = childNodeWithName("bar") as! SKSpriteNode
        
        levelSelect.selectedHandler = {
            
            let flapSFX = SKAction.playSoundFileNamed("button", waitForCompletion: false)
            self.runAction(flapSFX)
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = LevelSelect(fileNamed:"LevelSelect") as LevelSelect!
            scene.backgroundMusicPlayer = self.backgroundMusicPlayer
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            
            /* Start game scene */
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
        }
        
        creditsButton = childNodeWithName("creditsButton") as! MSButtonNode
        
        creditsButton.selectedHandler = {
            
            let skView = self.view as SKView!
            /* Load Game scene */
            let scene = Credits(fileNamed:"Credits") as Credits!
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Start game scene */
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
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
    
    
    
    func playBackgroundMusic(filename: String) {
       
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
             backgroundMusicPlayer.volume = backgroundMusicPlayer.volume/6
        } catch let error as NSError {
            print(error.description)
        }
        
    }

}
