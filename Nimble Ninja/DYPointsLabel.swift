//
//  DYPointsLabel.swift
//  Nimble Ninja
//
//  Created by Dongyu Zhai on 2/8/16.
//  Copyright © 2016 Dongyu Zhai. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class DYPointsLabel: SKLabelNode {
    
    var number = 0
    
    init(num: Int) {
        super.init()
        
        fontColor = UIColor.blackColor()
        fontName = "Helvetica"
        fontSize = 24.0
        
        number = num
        text = "\(num)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func increment() {
        number += 1
        text = "\(number)"
    }
    
    func setTo(num: Int) {
        self.number = num
        text = "\(self.number)"
    }
    
}