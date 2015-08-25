import UIKit
import XCTest

class FoodTrackerTests: XCTestCase {
    func testMicropostInitialization() {
        // Success case.
        let potentialItem = Micropost(name: "Newest micropost", photo: nil)
        XCTAssertNotNil(potentialItem)
        
        // Failure case.
        let noName = Micropost(name: "", photo: nil)
        XCTAssertNil(noName, "Empty name is invalid")
    }
}
// MARK: FoodTracker Tests