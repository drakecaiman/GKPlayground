import XCTest
@testable import GKPlayground

final class GKPlaygroundTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }

//  func testNodeMap() {
//    print(BodyMap.BODY_MAP)
//    print("\(BodyMap.BODY_MAP.bodies.count) bodies found")
//  }

  func testGKStateNodeMap() {
    let nodeMap = NodeMap(fromStates: [MultipleOutState(), Out1State(), Out2State(), Out3State()])
    let bodyMap = BodyMap(withNodeMap: nodeMap)
    print(bodyMap)
    print("\(nodeMap.contents.count) elements found")
    print("\(bodyMap.bodies.count) bodies found")
  }

    static var allTests = [
        ("testExample", testExample),
    ]
}
