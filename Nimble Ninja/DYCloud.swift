//
//  DYCloud.swift
//  Nimble Ninja
//
//  Created by Dongyu Zhai on 2/8/16.
//  Copyright © 2016 Dongyu Zhai. All rights reserved.
//

import Foundation
import SpriteKit

class DYCloud: SKShapeNode {
    
    init(size: CGSize) {
        super.init()
        let path = CGPathCreateWithEllipseInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height), nil)
        self.path = path
        fillColor = UIColor.whiteColor()
        
        startMoving()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveByX(-10, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    
}