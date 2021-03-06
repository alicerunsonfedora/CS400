//
//  GameSignalSender.swift
//  Costumemaster
//
//  Created by Marquis Kurt on 8/26/20.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import SpriteKit

/// A base class that determines an input.
public class GameSignalSender: GameStructureObject {

    // MARK: STORED PROPERTIES

    /// Whether the input is currently active. Defaults to false.
    public var active: Bool = false

    /// The method(s) that this input will activate. Default is only by player intervention.
    public var activationMethod: [InputMethod] = [.activeByPlayerIntervention]

    /// The kind of sender. Defaults to a trigger.
    public var kind: GameSignalKind = .trigger

    /// The input's associated receiver.
    var receivers: [GameSignalReceivable]

    /// The name of the base texture for this input.
    var baseTexture: String

    /// The number of seconds it takes for the input to toggle.
    var cooldown: Double

    // MARK: COMPUTED PROPERTIES
    /// The texture for this input, accounting for active states.
    var activeTexture: SKTexture {
        return SKTexture(imageNamed: self.baseTexture + (self.active ? "_on" : "_off"))
    }

    /// The description for this class.
    public override var description: String {
        return "\(self.className)(active: \(self.active), gate: \(self.activationMethod), "
        + "outputs: \(self.receivers), position: \(self.worldPosition))"
    }

    /// An enumeration that defines the different types of inputs that are used in the game.
    public enum InputMethod {

        /// The input is active once and remains active permanently.
        case activeOncePermanently

        /// The input is active when a player interacts with it, either by distance or collision.
        case activeByPlayerIntervention

        /// The input is active on a timer and then deactivates.
        case activeOnTimer

        /// The input is active and can be toggled accordingly.
        case activeOnToggle
    }

    // MARK: CONSTRUCTOR
    /// Initialize the input.
    /// - Parameter textureName: The name of the texture for this input.
    /// - Parameter inputMethods: The means of which this input will be activated by.
    public init(textureName: String, by inputMethods: [InputMethod], at position: CGPoint) {
        self.baseTexture = textureName
        self.activationMethod = inputMethods
        self.cooldown = 0
        self.receivers = []
        super.init(
            with: SKTexture(imageNamed: textureName + "_off"),
            size: SKTexture(imageNamed: textureName + "_off").size()
        )
        self.worldPosition = position
        self.texture = self.activeTexture
    }

    // MARK: CONSTRUCTOR
    /// Initialize the input.
    /// - Parameter textureName: The name of the texture for this input.
    /// - Parameter inputMethods: The means of which this input will be activated by.
    /// - Parameter timer: The number of seconds it takes for this input to toggle states.
    public init(
        textureName: String,
        by inputMethods: [InputMethod],
        at position: CGPoint,
        with timer: Double
    ) {
        self.baseTexture = textureName
        self.cooldown = timer
        self.activationMethod = inputMethods
        self.receivers = []
        super.init(
            with: SKTexture(imageNamed: textureName + "_off"),
            size: SKTexture(imageNamed: textureName + "_off").size()
        )
        self.worldPosition = position
        self.texture = self.activeTexture
    }

    /// Required initializer for this class. Will result in a fatal error if you initialize the object this way.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: METHODS
    /// Toggle the active state for this input.
    private func toggle() {
        self.active.toggle()
        self.texture = self.activeTexture
    }

    /// Set the state of this input as active.
    private func setActiveState() {
        self.active = true
        self.texture = self.activeTexture
        for receiver in self.receivers {
            receiver.update()
        }
    }

    /// Set the state of this input as inactive.
    private func setInactiveState() {
        self.active = false
        self.texture = self.activeTexture
    }

    /// Activate the input given an event and player.
    /// - Parameter event: The event handler to listen to and track.
    /// - Parameter player: The player to watch and track.
    public func activate(with event: NSEvent?, player: Player?, objects: [SKSpriteNode?] = []) {
        var activationEvents = [SKAction]()

        switch activationMethod {
        case activationMethod where activationMethod.contains(.activeByPlayerIntervention):
            let action = SKAction.run {
                if self.shouldActivateOnIntervention(with: player, objects: objects) {
                    self.setActiveState()
                    self.onActivate(with: event, player: player)
                } else {
                    self.setInactiveState()
                    self.onDeactivate(with: event, player: player)
                }
            }
            activationEvents.append(action)
        case activationMethod where activationMethod.contains(.activeOnToggle):
            let action = SKAction.run {
                self.toggle()
                self.active
                    ? self.onActivate(with: event, player: player)
                    : self.onDeactivate(with: event, player: player)
            }
            activationEvents.append(action)
        default:
            let action = SKAction.run {
                self.setActiveState()
                self.onActivate(with: event, player: player)
            }
            activationEvents.append(action)
        }

        if activationMethod.contains(.activeOnTimer) {
            activationEvents += [
                SKAction.wait(forDuration: self.cooldown),
                SKAction.run {
                    self.setInactiveState()
                    self.onDeactivate(with: event, player: player)
                }
            ]
        }

        self.run(SKAction.sequence(activationEvents))

    }

    /// Whether the input should turn on/off based on player or object intervention.
    /// - Parameter player: The player to listen to for intervention.
    /// - Parameter objects: The objects to listen to for intervention.
    /// - Returns: Whether the input should activate given the intervention criteria.
    /// - Important: This method should be implemented on inputs that listen to player intervention.
    /// This will default to false otherwise.
    public func shouldActivateOnIntervention(with player: Player?, objects: [SKSpriteNode?]) -> Bool {
        return false
    }

    /// Run any post-activation methods.
    /// - Parameter event: The event handler that triggered the activation.
    /// - Parameter player: The player that triggered the activation.
    public func onActivate(with event: NSEvent?, player: Player?) {
        print("onActivate has not been implemented.")
    }

    /// Run any post-deactivation methods.
    /// - Parameter event: The event handler that triggered the activation.
    /// - Parameter player: The player that triggered the activation.
    public func onDeactivate(with event: NSEvent?, player: Player?) {
        print("onDeactivate has not been implemented.")
    }
}
