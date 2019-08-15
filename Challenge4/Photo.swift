//
//  Photo.swift
//  Challenge4
//
//  Created by Adrimi on 15/08/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class Photo: Codable {

    var name: String
    var image: String
    var count: Int
    
    init(name: String, image: String, count: Int) {
        self.name = name
        self.image = image
        self.count = count
    }
    
}
