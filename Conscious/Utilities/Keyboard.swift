//
//  Keyboard.swift
//  Costumemaster
//
//  Created by Marquis Kurt on 8/29/20.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let moveUp = Self("moveUp", default: Shortcut(.w))
    static let moveDown = Self("moveDown", default: Shortcut(.s))
    static let moveLeft = Self("moveLeft", default: Shortcut(.a))
    static let moveRight = Self("moveRight", default: Shortcut(.d))
    static let previousCostume = Self("previousCostume", default: Shortcut(.g))
    static let nextCostume = Self("nextCostume", default: Shortcut(.f))
    static let use = Self("use", default: Shortcut(.e))
}

extension KeyboardShortcuts {
    /// Reset all keyboard shortcuts.
    static func resetAll() {
        KeyboardShortcuts.reset([.moveUp, .moveRight, .moveDown, .moveLeft, .nextCostume, .previousCostume, .use])
    }
}