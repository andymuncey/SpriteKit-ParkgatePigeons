//
//  Pigeon.swift
//  ParkgatePigeons
//
//  Created by Andrew Muncey on 12/06/2015.
//  Copyright (c) 2015 University of Chester. All rights reserved.
//

//import Foundation
import SpriteKit


protocol PigeonDelegate{
    func pigeonKilled()
}

class Pigeon : SKSpriteNode {
    var delegate : PigeonDelegate?
    
    init(){
        let texture = SKTexture(imageNamed: "pigeon-alive.png")
        super.init(texture: texture, color: nil, size: texture.size())
        name = "pigeon"
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        
        //call the pigeonKilled Method, only if the delegate exists
        delegate?.pigeonKilled()
    }
    
}