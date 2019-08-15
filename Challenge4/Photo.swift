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
    var date: Date
    
    init(name: String, image: String, date: Date) {
        self.name = name
        self.image = image
        self.date = date
    }
    
    func formattedDate() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format.string(from: self.date)
    }
}
