//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by usr0600370 on 2015/08/18.
//  Copyright (c) 2015年 usr0600370. All rights reserved.
//

import UIKit
import XCTest

class FoodTrackerTests: XCTestCase {
    // Tests to confirm that the Meal initializer returns when no name or a negative rating is provided.

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