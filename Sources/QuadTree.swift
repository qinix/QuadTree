//
//  QuadTree.swift
//  QuadTree
//
//  Created by Eric Zhang on 27/11/2016.
//
//

import Foundation

public class QuadTree<T: TreeItem> {
    private var bounds: Bounds
    private var root: QuadTreeChild<T>
    private(set) public var count: Int = 0
    
    public init(bounds: Bounds, items: [T]) {
        self.bounds = bounds
        root = QuadTreeChild<T>()
        count = 0
        
        items.forEach { (item) in
            _ = add(item)
        }
    }
    
    public func add(_ item: T) -> Bool {
        let point = item.point
        if point.x > bounds.maxX || point.x < bounds.minX || point.y > bounds.maxY || point.y < bounds.minY {
            return false
        }
        
        _ = root.add(item, ownBounds: bounds, depth: 0)
        
        count += 1
        
        return true
    }
    
    public func remove(_ item: T) -> Bool {
        let point = item.point
        if point.x > bounds.maxX || point.x < bounds.minX || point.y > bounds.maxY || point.y < bounds.minY {
            return false
        }
        
        let removed = root.remove(item, ownBounds: bounds)
        if removed {
            count -= 1
        }
        
        return removed
    }
    
    public func clear() {
        root = QuadTreeChild<T>()
        count = 0
    }
    
    public func search(bounds: Bounds) -> [T] {
        return root.search(bounds: bounds, ownBounds: self.bounds)
    }
}
