//
//  GameScene.swift
//  Nimble Ninja
//
//  Created by Dongyu Zhai on 1/8/16.
//  Copyright (c) 2016 Dongyu Zhai. All rights reserved.
//


import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameLayer = SKNode()
    var settingLayer = SKNode()
    
    var movingGround: DYMovingGround!
    var hero: DYHero!
    var cloudGenerator: DYCloudGenerator!
    var wallGenerator: DYWallGenerator!
    
    var isStarted = false
    var isGameOver = false
    var isGamePaused = false
    
    var currentLevel = 0
    
    var settingButton: SKSpriteNode!
    var playButton: SKSpriteNode!
    var settingNode: SKSpriteNode!
    var countDownLabel: SKLabelNode!
    
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        addMovingGround()
        addHero()
        addCloudGenerator()
        addWallGenerator()
        addTapToStartLabel()
        addPointsLabels()
        addPhysicsWorld()
        loadHighscore()
        //addSettingButton()
        
        self.addChild(gameLayer)
        settingLayer.zPosition = 100
        self.addChild(settingLayer)
        
        
    }
    
    
    
    func addSettingButton(){
        settingButton = SKSpriteNode(imageNamed: "pause")
        settingButton.name = "setting"
        settingButton.position = CGPointMake(20, 20)
        settingButton.xScale = 0.05
        settingButton.yScale = 0.05
        gameLayer.addChild(settingButton)
    }
    
    func addPlayButton(){
        playButton = SKSpriteNode(imageNamed: "play")
        playButton.name = "play"
        playButton.position = CGPointMake(view!.frame.size.width*0.5, view!.frame.size.height/2)
        playButton.xScale = 0.5
        playButton.yScale = 0.5
        settingLayer.addChild(playButton)
    }
    
    func addSettingNode(){
        let size = CGSizeMake(view!.frame.size.width*0.6, view!.frame.size.height/2)
        settingNode = DYSettingNode(size: size, position: CGPointMake(view!.frame.size.width*0.5, view!.frame.size.height/2))
        settingLayer.addChild(settingNode)
        addPlayButton()
    }
    
    func addMovingGround() {
        movingGround = DYMovingGround(size: CGSizeMake(view!.frame.width, kDYGroundHeight))
        movingGround.position = CGPointMake(0, view!.frame.size.height/2)
        gameLayer.addChild(movingGround)
    }
    
    func addHero() {
        hero = DYHero()
        hero.position = CGPointMake(70, movingGround.position.y + movingGround.frame.size.height/2 + hero.frame.size.height/2)
        gameLayer.addChild(hero)
        hero.breathe()
    }
    
    func addCloudGenerator() {
        cloudGenerator = DYCloudGenerator(color: UIColor.clearColor(), size: view!.frame.size)
        cloudGenerator.position = view!.center
        gameLayer.addChild(cloudGenerator)
        cloudGenerator.populate(7)
        cloudGenerator.startGeneratingWithSpawnTime(5)
    }
    
    func addWallGenerator() {
        wallGenerator = DYWallGenerator(color: UIColor.clearColor(), size: view!.frame.size)
        wallGenerator.position = view!.center
        gameLayer.addChild(wallGenerator)
    }
    
    func addTapToStartLabel() {
        let tapToStartLabel = SKLabelNode(text: "Tap to start!")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.x = view!.center.x
        tapToStartLabel.position.y = view!.center.y + 40
        tapToStartLabel.fontName = "Helvetica"
        tapToStartLabel.fontColor = UIColor.blackColor()
        tapToStartLabel.fontSize = 22.0
        gameLayer.addChild(tapToStartLabel)
        tapToStartLabel.runAction(blinkAnimation())
    }
    
    func addPointsLabels() {
        let pointsLabel = DYPointsLabel(num: 0)
        pointsLabel.position = CGPointMake(20.0, view!.frame.size.height - 35)
        pointsLabel.name = "pointsLabel"
        gameLayer.addChild(pointsLabel)
        
        let highscoreLabel = DYPointsLabel(num: 0)
        highscoreLabel.name = "highscoreLabel"
        highscoreLabel.position = CGPointMake(view!.frame.size.width - 20, view!.frame.size.height - 35)
        gameLayer.addChild(highscoreLabel)
        
        let highscoreTextLabel = SKLabelNode(text: "High")
        highscoreTextLabel.fontColor = UIColor.blackColor()
        highscoreTextLabel.fontSize = 14.0
        highscoreTextLabel.fontName = "Helvetica"
        highscoreTextLabel.position = CGPointMake(0, -20)
        highscoreLabel.addChild(highscoreTextLabel)
    }
    
    func addPhysicsWorld() {
        physicsWorld.contactDelegate = self
    }
    
    func loadHighscore() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let highscoreLabel = gameLayer.childNodeWithName("highscoreLabel") as! DYPointsLabel
        highscoreLabel.setTo(defaults.integerForKey("highscore"))
    }
    
    // MARK: - Game Lifecycle
    func start() {
        isStarted = true
        
        let tapToStartLabel = gameLayer.childNodeWithName("tapToStartLabel")
        tapToStartLabel?.removeFromParent()
        
        hero.stop()
        hero.startRunning()
        movingGround.start()
        
        wallGenerator.startGeneratingWallsEvery(1)
        
    }
    
    func gameOver() {
        isGameOver = true
        
        hero.runAction(SKAction.playSoundFileNamed("Sound/r_jump_big.mp3",waitForCompletion:false));
        
        // stop everything
        hero.fall()
        wallGenerator.stopWalls()
        movingGround.stop()
        hero.stop()
        
        // create game over label
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontColor = UIColor.blackColor()
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.position.x = view!.center.x
        gameOverLabel.position.y = view!.center.y + 40
        gameOverLabel.fontSize = 22.0
        gameLayer.addChild(gameOverLabel)
        gameOverLabel.runAction(blinkAnimation())
        
        
        // save current points label value
        let pointsLabel = gameLayer.childNodeWithName("pointsLabel") as! DYPointsLabel
        let highscoreLabel = gameLayer.childNodeWithName("highscoreLabel") as! DYPointsLabel
        
        if highscoreLabel.number < pointsLabel.number {
            highscoreLabel.setTo(pointsLabel.number)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(highscoreLabel.number, forKey: "highscore")
        }
    }
    
    func saveHighScore(score: Int) {
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "nimbleninjaLB")
            scoreReporter.value = Int64(score)
            
            let scoreArray : [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: nil)
            
        }
    }
    
    func restart() {
        cloudGenerator.stopGenerating()
        
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .AspectFill
        
        view!.presentScene(newScene)
    }
    
    func pauseGame() {
        gameLayer.paused = true
        isGamePaused = true
        addSettingNode()
        wallGenerator.stopGenerating()
    }
    
    func resumeGame() {
        gameLayer.paused = false
        isGamePaused = false
        playButton.removeFromParent()
        settingNode.removeFromParent()
        wallGenerator.startGeneratingWallsEvery(kLevelGenerationTimes[accelaritionOfWall()])
    }
    
    func addCountDownLabel() {
        setCountDown("3")
        countDownLabel.fontColor = UIColor.blackColor()
        countDownLabel.fontName = "Helvetica"
        countDownLabel.position.x = view!.center.x
        countDownLabel.position.y = view!.center.y + 40
        countDownLabel.fontSize = 22.0
        settingLayer.addChild(countDownLabel)
    }
    
    func setCountDown(num: String) {
        countDownLabel = SKLabelNode(text: num)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let locationG = touch.locationInNode(gameLayer)
            let locationS = touch.locationInNode(settingLayer)
            //this will detect touch on setting button
            if gameLayer.nodeAtPoint(locationG) == gameLayer.childNodeWithName("setting") {
                pauseGame()
            }
            if settingLayer.nodeAtPoint(locationS) == settingLayer.childNodeWithName("play"){
                resumeGame()
//                addCountDownLabel()
//                let countTime = (Int64(NSEC_PER_SEC) * 3)
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, countTime), dispatch_get_main_queue(), { () -> Void in
//                    self.resumeGame()
//                })
            }
        }
        
        if isGameOver {
            restart()
        } else if !isStarted {
            start()
        } else {
            hero.flip()
            hero.runAction(SKAction.playSoundFileNamed("Sound/r_jump.mp3",waitForCompletion:false));
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if wallGenerator.wallTrackers.count > 0 && !isGameOver {
                let wall = wallGenerator.wallTrackers[0] as DYWall
                let wallLocation = wallGenerator.convertPoint(wall.position, toNode: self)
                if wallLocation.x < hero.position.x {
                    wallGenerator.wallTrackers.removeAtIndex(0)
                    
                    let pointsLabel = gameLayer.childNodeWithName("pointsLabel") as! DYPointsLabel
                    pointsLabel.increment()
                    
                    if pointsLabel.number % kNumberOfPointsPerLevel == 0 {
                        currentLevel+=1
                        wallGenerator.stopGenerating()
                        wallGenerator.startGeneratingWallsEvery(kLevelGenerationTimes[accelaritionOfWall()])
                    }
                }
        }
    }
    
    func accelaritionOfWall()->Int{
        if currentLevel < 4 {
            return currentLevel
        }
        else {
            return 4
        }
    }
    
    // MARK: - SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        if !isGameOver {
            gameOver()
        }
    }
    
    // MARK: - Animations
    func blinkAnimation() -> SKAction {
        let duration = 0.4
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: duration)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatActionForever(blink)
    }
}
