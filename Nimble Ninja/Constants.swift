//
//  Constants.swift
//  Nimble Ninja
//
//  Created by Dongyu Zhai on 2/8/16.
//  Copyright © 2016 Dongyu Zhai. All rights reserved.
//

import Foundation
import UIKit

// Configuration
let kDYGroundHeight: CGFloat = 20.0

// Initial Variables
let kDefaultXToMovePerSecond: CGFloat = 320.0

// Collision Detection
let heroCategory: UInt32 = 0x1 << 0
let wallCategory: UInt32 = 0x1 << 1

//Game Variables
let kNumberOfPointsPerLevel = 5
let kLevelGenerationTimes: [NSTimeInterval] = [1.0, 0.8, 0.6, 0.4, 0.3]