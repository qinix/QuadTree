//
//  Point.swift
//  QuadTree
//
//  Created by Eric Zhang on 27/11/2016.
//
//

import Foundation

public struct Point {
    var x, y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

extension Point: Equatable {}

public func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
