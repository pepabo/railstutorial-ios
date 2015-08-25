import UIKit
import XCTest

class FoodTrackerTests: XCTestCase {
    func testMicropostInitialization() {
        // Success case.
        let potentialItem = Micropost(content: "Newest micropost", picture: nil)
        XCTAssertNotNil(potentialItem)
        
        // Failure case.
        let noContent = Micropost(content: "", picture: nil)
        XCTAssertNil(noContent, "Empty content is invalid")
    }
}
// MARK: FoodTracker Tests