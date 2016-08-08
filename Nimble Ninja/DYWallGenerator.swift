//
//  DYWallGenerator.swift
//  Nimble Ninja
//
//  Created by Dongyu Zhai on 2/8/16.
//  Copyright © 2016 Dongyu Zhai. All rights reserved.
//

import Foundation
import SpriteKit

class DYWallGenerator: SKSpriteNode {
    
    var generationTimer: NSTimer?
    var walls = [DYWall]()
    var wallTrackers = [DYWall]()
    
    func startGeneratingWallsEvery(seconds: NSTimeInterval) {
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: #selector(DYWallGenerator.generateWall), userInfo: nil, repeats: true)
        
    }
    
    func stopGenerating() {
        generationTimer?.invalidate()
    }
    
    func generateWall() {
        if !self.paused {
            var scale: CGFloat
            let rand = arc4random_uniform(2)
            if rand == 0 {
                scale = -1.0
            } else {
                scale = 1.0
            }
            
            let wall = DYWall()
            wall.position.x = size.width/2 + wall.size.width/2
            wall.position.y = scale * (kDYGroundHeight/2 + wall.size.height/2)
            walls.append(wall)
            wallTrackers.append(wall)
            addChild(wall)
        }
        else {
            
        }
    }
    
    func stopWalls() {
        stopGenerating()
        for wall in walls {
            wall.stopMoving()
        }
    }
    
    func destroyWalls() {
        for wall in walls{
            if wall.position.x < -size.width/2 {
                wall.removeFromParent()
            }
        }
    }
}