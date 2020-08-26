//
//  LevelDataConfiguration.swift
//  Conscious
//
//  Created by Marquis Kurt on 8/26/20.
//

import Foundation

/// A data structure used to determine the properties of a level based on a user data dictionary.
public struct LevelDataConfiguration: Codable {
    /// The ID that determines what costumes are avaiable, with 0 indicating no costumes annd 3 indicating all costumes.
    public let costumeID: Int

    /// The name of the SKScene that will load after the current scene this level configuration is attached to.
    public let linksToNextScene: String

    /// A default level configuration with no costumes loaded and the next scene set to the main menu.
    static var `default`: LevelDataConfiguration {
        return LevelDataConfiguration(costumeID: 0, nextScene: "MainMenu")
    }

    /// Initialize a level configuration.
    /// - Parameter costumeID: The costume ID that determines what costumes are available.
    /// - Parameter nextScene: The SKScene name that will load after the scene attached to this configuration.
    public init(costumeID: Int, nextScene: String) {
        self.costumeID = costumeID
        self.linksToNextScene = nextScene
    }

    /// Initialize a level configuration.
    /// - Parameter userData: The user data dictionary to read data from and generate a configuration.
    public init(from userData: NSMutableDictionary) {
        self.costumeID = userData["availableCostumes"] as? Int ?? 0
        self.linksToNextScene = userData["levelLink"] as? String ?? "MainMenu"
    }
}
