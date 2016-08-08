//
//  GameViewController.swift
//  Nimble Ninja
//
//  Created by Dongyu Zhai on 1/8/16.
//  Copyright (c) 2016 Dongyu Zhai. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {

    var scene: GameScene!
    var gameButton: UIButton!
    var pausePlayButton: UIButton!
    var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticatePlayer()
        
        //Configure the view
        skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        //create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        addGameButton()
        //addPausePlayBtn()
    }
    
    func addPausePlayBtn() {
        pausePlayButton = UIButton(type: UIButtonType.Custom)
        pausePlayButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        pausePlayButton.center = CGPointMake(self.view.frame.width - 30, self.view.frame.height - 30)
        pausePlayButton.setImage(UIImage(named: "pause"), forState: .Normal)
        pausePlayButton.addTarget(self, action: #selector(GameViewController.pausePlayGame), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(pausePlayButton)
    }
    
    func pausePlayGame() {
        if skView.paused == false {
            skView.paused = true
            pausePlayButton.setImage(UIImage(named: "play"), forState: .Normal)
        }
        else {
            skView.paused = false
            pausePlayButton.setImage(UIImage(named: "pause"), forState: .Normal)
        }
    }
    
    func addGameButton() {
        gameButton = UIButton(type: UIButtonType.Custom)
        gameButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        gameButton.center = CGPointMake(30, self.view.frame.height - 30)
        gameButton.setImage(UIImage(named: "gamecenter"), forState: .Normal)
        gameButton.addTarget(self, action: #selector(GameViewController.showLeaderboard), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(gameButton)
    }
    
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer()
        
        localPlayer.authenticateHandler = {
            (viewController, error) in
            if viewController != nil {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
            else {
                print("logged in")
            }
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
    
    func loadHighscore() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        saveHighScore(defaults.integerForKey("highscore"))
    }
    
    func showLeaderboard() {
        loadHighscore()
        let gc = GKGameCenterViewController()
        
        gc.gameCenterDelegate = self
        
        self.presentViewController(gc, animated: true, completion: nil)
        
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
