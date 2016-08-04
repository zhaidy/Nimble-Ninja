//
//  DYSetting.swift
//  Nimble Ninja
//
//  Created by Dongyu Zhai on 4/8/16.
//  Copyright © 2016 Dongyu Zhai. All rights reserved.
//

import Foundation
import SpriteKit

class DYSettingNode: SKSpriteNode {
    var settingNode: SKSpriteNode!
    
    init(size: CGSize, position: CGPoint) {
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        settingNode = SKSpriteNode(color: UIColor.clearColor(), size: size)
        settingNode.position = position
        addChild(settingNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
