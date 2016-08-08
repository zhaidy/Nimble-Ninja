//
//  DYMovingGround.swift
//  Nimble Ninja
//
//  Created by Dongyu Zhai on 1/8/16.
//  Copyright © 2016 Dongyu Zhai. All rights reserved.
//


import Foundation
import SpriteKit

class DYMovingGround: SKSpriteNode {
    
    let NUMBER_OF_SEGMENTS = 20
    let COLOR_ONE = UIColor(red: 88.0/255.0, green: 148.0/255.0, blue: 87.0/255.0, alpha: 1.0)
    let COLOR_TWO = UIColor(red: 120.0/255.0, green: 195.0/255.0, blue: 118.0/255.0, alpha: 1.0)
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.brownColor(), size: CGSizeMake(size.width*2, size.height))
        anchorPoint = CGPointMake(0, 0.5)
        
        for i in 0 ..< NUMBER_OF_SEGMENTS {
            var segmentColor: UIColor!
            if i % 2 == 0 {
                segmentColor = COLOR_ONE
            } else {
                segmentColor = COLOR_TWO
            }
            
            let segment = SKSpriteNode(color: segmentColor, size: CGSizeMake(self.size.width / CGFloat(NUMBER_OF_SEGMENTS), self.size.height))
            segment.anchorPoint = CGPointMake(0.0, 0.5)
            segment.position = CGPointMake(CGFloat(i)*segment.size.width, 0)
            addChild(segment)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func start() {
        if !self.paused {
            let adjustedDuration = NSTimeInterval(frame.size.width / kDefaultXToMovePerSecond)
            
            let moveLeft = SKAction.moveByX(-frame.size.width/2, y: 0, duration: adjustedDuration/2)
            let resetPosition = SKAction.moveToX(0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, resetPosition])
            
            runAction(SKAction.repeatActionForever(moveSequence))
        }
        else {
            
        }
    }
    
    func stop() {
        removeAllActions()
    }
}