//
//  GameSignalSender.swift
//  Costumemaster
//
//  Created by Marquis Kurt on 8/26/20.
//

import Foundation
import SpriteKit

/// A base class that determines an input.
public class GameSignalSender: SKSpriteNode {

    // MARK: STORED PROPERTIES

    /// Whether the input is currently active. Defaults to false.
    public var active: Bool = false

    /// The method that this input will activate. Default is by player intervention.
    public var activationMethod: GameSignalInputMethod = .activeByPlayerIntervention

    /// The input's associated receiver.
    var receiver: GameSignalReceivable?

    /// The name of the base texture for this input.
    var baseTexture: String

    /// The number of seconds it takes for the input to toggle.
    var cooldown: Double

    // MARK: COMPUTED PROPERTIES
    /// The texture for this input, accounting for active states.
    var activeTexture: SKTexture {
        return SKTexture(imageNamed: self.baseTexture + (self.active ? "_on" : "_off"))
    }

    // MARK: CONSTRUCTOR
    /// Initialize the input.
    /// - Parameter textureName: The name of the texture for this input.
    /// - Parameter inputMethod: The means of which this input will be activated by.
    public init(textureName: String, by inputMethod: GameSignalInputMethod) {
        self.baseTexture = textureName
        self.activationMethod = inputMethod
        self.cooldown = 0
        super.init(
            texture: SKTexture(imageNamed: textureName + "_off"),
            color: .clear,
            size: SKTexture(imageNamed: textureName + "_off").size()
        )
        self.texture = self.activeTexture
    }

    // MARK: CONSTRUCTOR
    /// Initialize the input.
    /// - Parameter textureName: The name of the texture for this input.
    /// - Parameter inputMethod: The means of which this input will be activated by.
    /// - Parameter timer: The number of seconds it takes for this input to toggle states.
    public init(textureName: String, by inputMethod: GameSignalInputMethod, with timer: Double) {
        self.baseTexture = textureName
        self.cooldown = timer
        self.activationMethod = inputMethod
        super.init(
            texture: SKTexture(imageNamed: textureName + "_off"),
            color: .clear,
            size: SKTexture(imageNamed: textureName + "_off").size()
        )
        self.texture = self.activeTexture
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: METHODS
    /// Toggle the active state for this input.
    private func toggle() {
        self.active.toggle()
    }

    /// Activate the input given an event and player.
    /// - Parameter event: The event handler to listen to and track.
    /// - Parameter player: The player to watch and track.
    public func activate(with event: NSEvent?, player: Player?) {
        switch activationMethod {
        case .activeByPlayerIntervention:
            // TODO: Complete this method
            break
        case .activeOnTimer:
            self.run(
                SKAction.sequence(
                    [
                        SKAction.run { self.toggle() },
                        SKAction.wait(forDuration: self.cooldown),
                        SKAction.run { self.toggle() }
                    ]
                )
            )
        case .activeOncePermanently:
            self.toggle()
        }
    }
}
