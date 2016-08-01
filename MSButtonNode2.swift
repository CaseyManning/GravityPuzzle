//
//  MSButtonNode.swift
//  HoppyBunny
//
//  Created by Martin Walsh on 20/02/2016.
//  Copyright (c) 2016 Make School. All rights reserved.
//

import SpriteKit

enum MSButtonNode2State {
    case Active, Selected, Hidden
}

class MSButtonNode2: SKSpriteNode {
    
    /* Setup a dummy action closure */
    var selectedHandler: () -> Void = { print("No button action set") }
    
    var initialLouchLocation = CGPoint()
    var link: SKSpriteNode!
    
    /* Button state management */
    var state: MSButtonNode2State = .Active {
        didSet {
            switch state {
            case .Active:
                /* Enable touch */
                self.userInteractionEnabled = true
                
                /* Visible */
                link.alpha = 1
                break
            case .Selected:
                /* Semi transparent */
                link.alpha = 0.7
                break
            case .Hidden:
                /* Disable touch */
                self.userInteractionEnabled = false
                
                /* Hide */
                link.alpha = 0
                break
            }
        }
    }
    
    /* Support for NSKeyedArchiver (loading objects from SK Scene Editor */
    required init?(coder aDecoder: NSCoder) {
        
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
        
        /* Enable touch on button node */
        self.userInteractionEnabled = true
    }
    
    //init(imageNamed: String) {
    //super.init(imageNamed: imageNamed)
    //self.userInteractionEnabled = true
    //}
    
    // MARK: - Touch handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        state = .Selected
        
        for touch in touches {
            initialLouchLocation = touch.locationInNode(self)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if abs(touch.locationInNode(self).x - initialLouchLocation.x) > 80 {
                state = .Active
                return
            }
            if abs(touch.locationInNode(self).y - initialLouchLocation.y) > 80 {
                state = .Active
                return
            }
        }
        selectedHandler()
        state = .Active
    }
    
}