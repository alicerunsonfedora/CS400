//
//  Tilemaps.swift
//  Costumemaster
//
//  Created by Marquis Kurt on 9/2/20.
//

import Foundation
import SpriteKit

extension SKTileMapNode {
    /// Iterate through the tilemap and apply a function to each tile.
    /// - Parameter parent: The parent node to hook up the resulting sprites to.
    /// - Parameter handler: The function that will be applied on every tile.
    /// - Author: Marquis Kurt
    func parse(applyTo parent: SKNode?, handler: ((TilemapParseData) -> Void)) {
        // Calculate information about the tilemap's size.
        let mapUnit = self.tileSize
        let unit = mapUnit
        let mapHalfWidth = CGFloat(self.numberOfColumns) / (mapUnit.width * 2)
        let mapHalfHeight = CGFloat(self.numberOfRows) / (mapUnit.height * 2)
        let origin = self.position

        // Seperate the tilemap into several nodes.
        for col in 0..<self.numberOfColumns {
            for row in 0..<self.numberOfRows {
                if let defined = self.tileDefinition(atColumn: col, row: row) {
                    let texture = defined.textures[0]
                    let spriteX = CGFloat(col) * mapUnit.width - mapHalfWidth + (mapUnit.width / 2)
                    let spriteY = CGFloat(row) * mapUnit.height - mapHalfHeight + (mapUnit.height / 2)

                    // Change the texure's filtering method to allow pixelation.
                    texture.filteringMode = .nearest

                    // Create the sprite node.
                    let sprite = SKSpriteNode(texture: texture)
                    sprite.position = CGPoint(x: spriteX + origin.x, y: spriteY + origin.y)
                    sprite.zPosition = 1
                    sprite.isHidden = false

                    // Create the data.
                    let data = TilemapParseData(
                        definition: defined,
                        column: col,
                        row: row,
                        unit: unit,
                        sprite: sprite,
                        texture: texture
                    )

                    handler(data)
                }
            }
        }

    }
}
