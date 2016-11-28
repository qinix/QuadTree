import XCTest
@testable import QuadTree

class PointItem: TreeItem, Equatable {
    var point: Point
    
    init(point: Point) {
        self.point = point
    }
}
func ==(lhs: PointItem, rhs: PointItem) -> Bool {
    return lhs.point == rhs.point
}

class QuadTreeTests: XCTestCase {
    func testAdd() {
        var tree = QuadTree(bounds: Bounds(minX: -1, minY: -1, maxX: 1, maxY: 1), items: [PointItem]())
        let item = PointItem(point: Point(x: 0.5, y: 0.5))
        let result = tree.add(item)
        XCTAssertTrue(result)
        XCTAssertEqual(tree.count, 1)
    }
    
    func testAddIgnored() {
        var tree = QuadTree(bounds: Bounds(minX: -0.2, minY: -0.2, maxX: 0.2, maxY: 0.2), items: [PointItem]())
        let item = PointItem(point: Point(x: 0.5, y: 0.5))
        let result = tree.add(item)
        
        XCTAssertFalse(result)
        XCTAssertEqual(tree.count, 0)
    }
    
    func testRemoveAddedItem() {
        var tree = QuadTree(bounds: Bounds(minX: -1, minY: -1, maxX: 1, maxY: 1), items: [PointItem]())
        let item = PointItem(point: Point(x: 0.5, y: 0.5))
        _ = tree.add(item)
        
        let item2 = PointItem(point: Point(x: 0.5, y: 0.5))
        let result = tree.remove(item2)
        
        XCTAssertTrue(result)
        XCTAssertEqual(tree.count, 0)
    }
    
    func testSearch() {
        var tree = QuadTree(bounds: Bounds(minX: -1, minY: -1, maxX: 1, maxY: 1), items: [PointItem]())
        _ = tree.add(PointItem(point: Point(x: 0.5, y: 0.5)))
        _ = tree.add(PointItem(point: Point(x: -0.5, y: 0.5)))
        _ = tree.add(PointItem(point: Point(x: -0.5, y: -0.5)))
        _ = tree.add(PointItem(point: Point(x: -0.5, y: -0.5)))
        
        var items = tree.search(bounds: Bounds(minX: -1, minY: -1, maxX: 1, maxY: 1))
        XCTAssertEqual(items.count, 4)
        
        items = tree.search(bounds: Bounds(minX: -1, minY: -1, maxX: -0.6, maxY: -0.6))
        XCTAssertEqual(items.count, 0)
        
        items = tree.search(bounds: Bounds(minX: 0.6, minY: 0.6, maxX: 1, maxY: 1))
        XCTAssertEqual(items.count, 0)
        
        items = tree.search(bounds: Bounds(minX: 0, minY: 0, maxX: 0.6, maxY: 0.6))
        XCTAssertEqual(items.count, 1)
        
        items = tree.search(bounds: Bounds(minX: -1, minY: -1, maxX: 1, maxY: 0))
        XCTAssertEqual(items.count, 2)
    }
    
    func testSearchWithRandomizedItems() {
        var tree = QuadTree(bounds: Bounds(minX: -1, minY: -1, maxX: 1, maxY: 1), items: [PointItem]())
        itemsFullyInside(bounds: Bounds(minX: -1, minY: -1, maxX: 0, maxY: 0), count: 10).forEach { (item) in
            _ = tree.add(item)
        }
        itemsFullyInside(bounds: Bounds(minX: -1, minY: 0, maxX: 0, maxY: 1), count: 20).forEach { (item) in
            _ = tree.add(item)
        }
        itemsFullyInside(bounds: Bounds(minX: 0, minY: 0, maxX: 1, maxY: 1), count: 30).forEach { (item) in
            _ = tree.add(item)
        }
        itemsFullyInside(bounds: Bounds(minX: 0, minY: -1, maxX: 1, maxY: 0), count: 40).forEach { (item) in
            _ = tree.add(item)
        }
        
    }
    
    func itemsFullyInside(bounds: Bounds, count: Int) -> [PointItem] {
        var items: [PointItem] = []
        (1...count).forEach { (_) in
            items.append(PointItem(point: Point(x: randd(min: bounds.minX + DBL_EPSILON, max: bounds.maxX - DBL_EPSILON), y: randd(min: bounds.minY + DBL_EPSILON, max: bounds.maxY - DBL_EPSILON))))
        }
        return items
    }
    
    func randd(min: Double, max: Double) -> Double {
        let range = max - min
        return min + range * Double(arc4random_uniform(1000)) / 1000
    }


    static var allTests : [(String, (QuadTreeTests) -> () throws -> Void)] {
        return [
            ("testAdd", testAdd),
            ("testAddIgnored", testAddIgnored),
            ("testRemoveAddedItem", testRemoveAddedItem),
            ("testSearch", testSearch),
            ("testSearchWithRandomizedItems", testSearchWithRandomizedItems),
        ]
    }
}
