//
//  Bounds.swift
//  QuadTree
//
//  Created by Eric Zhang on 27/11/2016.
//
//

import Foundation

public struct Bounds {
    var minX, minY, maxX, maxY: Double
    
    public init(minX: Double, minY: Double, maxX: Double, maxY: Double) {
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
    }
    
    var midpoint: Point {
        return Point(x: (minX + maxX)/2, y: (minY + maxY)/2)
    }
    
    var topRightChild: Bounds {
        return Bounds(minX: midpoint.x, minY: midpoint.y, maxX: maxX, maxY: maxY)
    }
    
    var topLeftChild: Bounds {
        return Bounds(minX: minX, minY: midpoint.y, maxX: midpoint.x, maxY: maxY)
    }
    
    var bottomRightChild: Bounds {
        return Bounds(minX: midpoint.x, minY: minY, maxX: maxX, maxY: midpoint.y)
    }
    
    var bottomLeftChild: Bounds {
        return Bounds(minX: minX, minY: minY, maxX: midpoint.x, maxY: midpoint.y)
    }
    
    public func isIntersectsWith(bounds: Bounds) -> Bool {
        return (!(self.maxY < bounds.minY || bounds.maxY < self.minY) &&
                !(self.maxX < bounds.minX || bounds.maxX < self.minX))
    }
}
