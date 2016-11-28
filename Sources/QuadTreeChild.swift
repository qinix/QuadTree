//
//  QuadTreeChild.swift
//  QuadTree
//
//  Created by Eric Zhang on 27/11/2016.
//
//

import Foundation

public class QuadTreeChild<T: TreeItem> {
    let MAX_ELEMENTS = 64, MAX_DEPTH = 30
    var topRight, topLeft, bottomRight, bottomLeft: QuadTreeChild?
    var items: Array<T>?
    
    init() {
        items = []
    }

    func add(_ item: T, ownBounds bounds: Bounds, depth: Int) {
        if items!.count >= MAX_ELEMENTS && depth < MAX_DEPTH {
            split(ownBounds: bounds, depth: depth)
        }
        
        if topRight != nil {
            let itemPoint = item.point
            let midPoint = bounds.midpoint
            
            if itemPoint.y > midPoint.y {
                if itemPoint.x > midPoint.x {
                    _ = topRight?.add(item, ownBounds: bounds.topRightChild, depth: depth + 1)
                } else {
                    _ = topLeft?.add(item, ownBounds: bounds.topLeftChild, depth: depth + 1)
                }
            } else {
                if itemPoint.x > midPoint.x {
                    _ = bottomRight?.add(item, ownBounds: bounds.bottomRightChild, depth: depth + 1)
                } else {
                    _ = bottomLeft?.add(item, ownBounds: bounds.bottomLeftChild, depth: depth + 1)
                }
            }
        } else {
            items!.append(item)
        }
    }
    
    func remove(_ item: T, ownBounds: Bounds) -> Bool {
        if topRight != nil {
            let itemPoint = item.point
            let midPoint = ownBounds.midpoint
            
            if itemPoint.y > midPoint.y {
                if itemPoint.x > midPoint.x {
                    return (topRight?.remove(item, ownBounds: ownBounds.topRightChild))!
                } else {
                    return (topLeft?.remove(item, ownBounds: ownBounds.topLeftChild))!
                }
            } else {
                if (itemPoint.x > midPoint.x) {
                    return (bottomRight?.remove(item, ownBounds: ownBounds.bottomRightChild))!
                } else {
                    return (bottomLeft?.remove(item, ownBounds: ownBounds.bottomLeftChild))!
                }
            }
        }
        
        if let index = items?.index(of: item) {
            items?.remove(at: index)
            return true
        } else {
            return false
        }
    }
    
    func search(bounds: Bounds, ownBounds: Bounds) -> [T] {
        var result: [T] = []
        return search(bounds: bounds, ownBounds: ownBounds, result: &result)
    }
    
    func search(bounds: Bounds, ownBounds: Bounds, result: inout [T]) -> [T] {
        if topRight != nil {
            if ownBounds.topRightChild.isIntersectsWith(bounds: bounds) {
                return topRight!.search(bounds: bounds, ownBounds: ownBounds.topRightChild, result: &result)
            }
            if ownBounds.topLeftChild.isIntersectsWith(bounds: bounds) {
                return topLeft!.search(bounds: bounds, ownBounds: ownBounds.topLeftChild, result: &result)
            }
            if ownBounds.bottomRightChild.isIntersectsWith(bounds: bounds) {
                return bottomRight!.search(bounds: bounds, ownBounds: ownBounds, result: &result)
            }
            if ownBounds.bottomLeftChild.isIntersectsWith(bounds: bounds) {
                return bottomLeft!.search(bounds: bounds, ownBounds: ownBounds, result: &result)
            }
        } else {
            items?.forEach({ (item) in
                let point = item.point
                
                if point.x <= bounds.maxX && point.x >= bounds.minX && point.y <= bounds.maxY && point.y >= bounds.minY {
                    return result.append(item)
                }
            })
        }
        
        return result
    }
    
    func split(ownBounds: Bounds, depth: Int) {
        topRight = QuadTreeChild()
        topLeft = QuadTreeChild()
        bottomRight = QuadTreeChild()
        bottomLeft = QuadTreeChild()
        
        let pitems = self.items
        self.items = []
        pitems?.forEach({ (item) in
            self.add(item, ownBounds: ownBounds, depth: depth)
        })
        
    }
}
