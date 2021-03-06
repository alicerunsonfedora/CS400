//
//  EndAnimationScene.swift
//  Costumemaster
//
//  Created by Marquis Kurt on 9/17/20.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import SpriteKit
import GameKit

/// The SpriteKit scene class that runs the end animation.
class EndGameScene: SKScene {

    /// The character sprite to animate.
    var character: SKSpriteNode?

    /// Set up the scene, play the reveal animation, and unlock the "Underneath it All" achievement.
    override func sceneDidLoad() {

        self.scaleMode = .aspectFill

        if let char = childNode(withName: "Character") as? SKSpriteNode {
            self.character = char
            self.character?.texture?.filteringMode = .nearest
        }

        let animation = SKTextureAtlas(named: "Player_Change_Final").toFrames()

        let sequence = [
            SKAction.animate(with: animation, timePerFrame: 0.15),
            SKAction.run { GKAchievement.earn(with: .endReveal) },
            SKAction.wait(forDuration: 2.0),
            SKAction.run { self.didFinish() }
        ]
        self.character?.run(SKAction.sequence(sequence))

    }

    /// Return back to the main menu.
    func didFinish() {
        guard let menu = SKScene(fileNamed: "MainMenu") else { return }
        self.view?.presentScene(menu, transition: SKTransition.fade(withDuration: 2.0))
    }

}
