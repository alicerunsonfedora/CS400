//
//  GameSceneUtils.swift
//  Costumemaster
//
//  Created by Marquis Kurt on 8/26/20.
//

import Foundation

extension CGPoint {
    /// Find the distance between two points.
    /// - Parameter startPoint: The starting point of the line to get the distance of.
    /// - Parameter endPoint: The ending point of the line to get the distance of.
    /// - Returns: The distance between the two points.
    static func distance(from startPoint: CGPoint, to endPoint: CGPoint) -> CGFloat {
        let xDistance = pow(endPoint.x - startPoint.x, 2)
        let yDistance = pow(endPoint.y - startPoint.y, 2)
        return sqrt(xDistance + yDistance)
    }

    /// Find the distance between this point and another point.
    /// - Parameter point: The point to compare the distance of.
    /// - Returns: The distance between this point and the specified point.
    func distance(between point: CGPoint) -> CGFloat {
        return CGPoint.distance(from: point, to: self)
    }
}
