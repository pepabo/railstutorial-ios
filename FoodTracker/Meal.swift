//
//  Meal.swift
//  FoodTracker
//
//  Created by usr0600341 on 2015/08/19.
//  Copyright (c) 2015年 usr0600370. All rights reserved.
//

import UIKit

class Meal {
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?) {
        self.name = name
        self.photo = photo
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
}
