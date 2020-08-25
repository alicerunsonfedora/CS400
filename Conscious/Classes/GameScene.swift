//
//  GameScene.swift
//  Conscious
//
//  Created by Marquis Kurt on 6/28/20.
//

import SpriteKit
import GameplayKit
import Carbon.HIToolbox

/// The base class for a given level.
class GameScene: SKScene {

    // MARK: STORED PROPERTIES
    var playerNode: Player?
    var playerCamera: SKCameraNode?
    var unit: CGSize?

    // MARK: METHODS
    override func sceneDidLoad() {

        // Get the camera for this scene.
        guard let pCam = childNode(withName: "Camera") as? SKCameraNode else {
            sendAlert(
                "Check the appropriate level file and ensure an SKCameraNode called \"Camera\" exists.",
                withTitle: "The camera for this map is missing.",
                level: .critical) { _ in
                NSApplication.shared.terminate(nil)
            }
            return
        }
        self.playerCamera = pCam
        self.playerCamera?.setScale(0.5)

        // Get the tilemap for this scene.
        guard let tilemap = childNode(withName: "Tile Map Node") as? SKTileMapNode else {
            sendAlert(
                "Check the appropriate level file and ensure an SKTilemapNode called \"Tile Map Node\" exists.",
                withTitle: "The tilemap for this map is missing.",
                level: .critical) { _ in
                NSApplication.shared.terminate(nil)
            }
            return
        }

        // Calculate information about the tilemap's size.
        let mapUnit = tilemap.tileSize
        self.unit = mapUnit
        let mapHalfWidth = CGFloat(tilemap.numberOfColumns) / (mapUnit.width * 2)
        let mapHalfHeight = CGFloat(tilemap.numberOfRows) / (mapUnit.height * 2)
        let origin = tilemap.position

        // Seperate the tilemap into several nodes.
        for y in 0..<tilemap.numberOfColumns {
            for x in 0..<tilemap.numberOfRows {
                if let defined = tilemap.tileDefinition(atColumn: y, row: x) {
                    let texture = defined.textures[0]
                    let _x = CGFloat(y) * mapUnit.width - mapHalfWidth + (mapUnit.width / 2)
                    let _y = CGFloat(x) * mapUnit.height - mapHalfHeight + (mapUnit.height / 2)
                    let spritePosition = CGPoint(x: _x, y: _y)

                    // Create the sprite node.
                    let sprite = SKSpriteNode(texture: texture)
                    sprite.position = spritePosition
                    sprite.zPosition = 1
                    sprite.isHidden = false

                    // Give the walls a physics body.
                    if (defined.name?.contains("wall")) != nil {
                        let physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
                        physicsBody.restitution = 0
                        physicsBody.linearDamping = 1000
                        physicsBody.friction = 0.7

                        physicsBody.affectedByGravity = false
                        physicsBody.isDynamic = false
                        physicsBody.isResting = true
                        physicsBody.allowsRotation = false
                        sprite.physicsBody = physicsBody
                    }

                    // Add the node to the parent scene's tree and update the position.
                    self.addChild(sprite)
                    sprite.position = CGPoint(x: spritePosition.x + origin.x, y: spritePosition.y + origin.y)

                    // Instantiate the node as a player if the texture's name matches.
                    if defined.name == "Main" {
                        var costumes: [PlayerCostumeType] = [.default]
                        if let costumeEntry = self.userData?["availableCostumes"] {
                            costumes = Player.getCostumeSet(id: costumeEntry as? Int ?? 0)
                        }
                        self.playerNode = Player(texture: texture, allowCostumes: costumes)
                        self.playerNode?.position = sprite.position
                        self.playerNode?.zPosition = 1
                        self.playerNode?.isHidden = false
                        self.addChild(self.playerNode!)
                        sprite.removeFromParent()
                    }
                }
            }
        }

        // Delete the tilemap from memory.
        tilemap.tileSet = SKTileSet(tileGroups: [])
        tilemap.removeFromParent()

        // Check that a player was generated.
        if playerNode == nil {
            sendAlert(
                "Check the appropriate level file and ensure the SKTileMapNode includes a tile definition for the player.",
                withTitle: "The player for this map is missing.",
                level: .critical) { _ in
                NSApplication.shared.terminate(self)
            }
            return
        }

        // Update the camera and its position.
        self.camera = playerCamera
        self.playerCamera!.position = self.playerNode!.position
    }

    // MARK: EVENT TRIGGERS
    override func update(_ currentTime: TimeInterval) {
        // Update the camera's position.
        if self.camera?.position != self.playerNode?.position {
            self.camera?.run(SKAction.move(to: self.playerNode?.position ?? CGPoint(x: 0, y: 0), duration: 1))
        }
    }

    public override func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {

        // Check for movement keys and move the player node in the respective directions.
        case kVK_ANSI_W, kVK_UpArrow:
            self.playerNode?.move(.north, unit: self.unit!)
        case kVK_ANSI_S, kVK_DownArrow:
            self.playerNode?.move(.south, unit: self.unit!)
        case kVK_ANSI_A, kVK_LeftArrow:
            self.playerNode?.move(.west, unit: self.unit!)
        case kVK_ANSI_D, kVK_RightArrow:
            self.playerNode?.move(.east, unit: self.unit!)

        // Check for the costume switching key and switch to the next available costume.
        case kVK_ANSI_F:
            _ = self.playerNode?.nextCostume()
        default:
            break

        }
    }

    public override func keyUp(with event: NSEvent) {
        switch Int(event.keyCode) {

        // Stop movement when a movement key is released.
        case kVK_ANSI_W, kVK_ANSI_S, kVK_ANSI_A, kVK_ANSI_D, kVK_UpArrow, kVK_DownArrow, kVK_LeftArrow, kVK_RightArrow:
            self.playerNode?.halt()
        default:
            break
        }
    }
}
