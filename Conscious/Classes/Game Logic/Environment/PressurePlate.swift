//
//  PressurePlate.swift
//  Costumemaster
//
//  Created by Marquis Kurt on 9/4/20.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import SpriteKit

/// An input that uses pressure sensitivity to activate.
class GamePressurePlate: GameSignalSender {

    /// Whether the player left the range of the plate. Defaults to true.
    private var leftRange: Bool = true

    /// Whether the player is in range of the plate. Defaults to false.
    private var inRange: Bool = false

    /// Initialize a pressure plate.
    /// - Parameter position: The position of the plate in the matrix.
    public init(at position: CGPoint) {
        super.init(textureName: "plate", by: .activeByPlayerIntervention, at: position)
        self.kind = .pressurePlate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func shouldActivateOnIntervention(with player: Player?, objects: [SKSpriteNode?]) -> Bool {
        for object in objects where object?.physicsBody?.mass ?? 0 >= 50 {
            if object?.position.distance(between: self.position) ?? 0 < 64 { return true }
        }
        if player?.position.distance(between: self.position) ?? 0 <= 64 { return true }
        return false
    }

    public override func onActivate(with event: NSEvent?, player: Player?) {
        self.leftRange = false
        if !self.inRange {
            self.run(SKAction.sequence([
                SKAction.run { self.inRange = true },
                SKAction.playSoundFileNamed("plateOn", waitForCompletion: true)
            ]))
        }
    }

    public override func onDeactivate(with event: NSEvent?, player: Player?) {
        if let playerPos = player?.position {
            if playerPos.distance(between: self.position) >= 16 && !self.leftRange {
                self.run(SKAction.sequence([
                    SKAction.run { self.leftRange = true },
                    SKAction.run { self.inRange = false },
                    SKAction.playSoundFileNamed("plateOff", waitForCompletion: true)
                ]))
            }
        }
    }

}