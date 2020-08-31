//
//  ViewController.swift
//  Conscious
//
//  Created by Marquis Kurt on 6/28/20.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Cocoa
import SpriteKit
import GameplayKit
import GameKit

class ViewController: NSViewController, NSWindowDelegate {
    @IBOutlet var skView: SKView!

    /// A private tunnled copy of AppDelegate's preferences.
    private var settings: Preferences = AppDelegate.preferences

    /// The root scene for this controller.
    ///
    /// This is typically used when switching between scenes, but wanting to preserve the scene's state.
    /// Use this sparingly.
    var rootScene: SKScene?

    /// Sign in to Game Center and present the resulting controller.
    func authenticateWithGameCenter() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { (viewC: NSViewController?, error) in
            guard error == nil else { return }

            if let controller = viewC {
                self.presentAsSheet(controller)
            }
        }
    }

    override func viewDidAppear() {
        self.view.window?.delegate = self
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        var shouldClose = false
        if self.skView.scene?.name == "MainMenu" {
            NSApplication.shared.terminate(self)
            return true
        }
        confirm("Any unsaved progress will be lost.",
                withTitle: "Are you sure you want to quit?",
                level: .warning) { resp in
            if resp.rawValue == 1000 {
                NSApplication.shared.terminate(self)
                shouldClose = true
            }
        }
        return shouldClose
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.settings = Preferences()

        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        guard let scene = GKScene(fileNamed: "MainMenu") else {
            sendAlert(
                "Please reinstall the game.",
                withTitle: "Main Menu is missing",
                level: .critical
            ) { _ in NSApplication.shared.terminate(nil) }
            return
        }

        // swiftlint:disable:next force_cast
        guard let sceneNode = scene.rootNode as! MainMenuScene? else {
            return
        }

        guard let view = self.skView else {
            return
        }

        view.presentScene(sceneNode)
        view.ignoresSiblingOrder = true
        view.showsFPS = settings.showFramesPerSecond
        view.showsNodeCount = settings.showNodeCount
        view.showsPhysics = settings.showPhysicsBodies
        view.shouldCullNonVisibleNodes = true

        // Sign in to Game Center.
        self.authenticateWithGameCenter()
    }
}
