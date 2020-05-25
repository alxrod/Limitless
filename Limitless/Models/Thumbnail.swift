//
//  Thumbnail.swift
//  Limitless
//
//  Created by Alex Rodriguez on 5/24/20.
//  Copyright © 2020 Zankner Rodriguez. All rights reserved.
//

import SwiftUI

struct Thumbnail: Hashable {
    var key: String
    var image: UIImage
    var selected: Bool = false

    
    init(key: String, image: UIImage) {
        self.key = key
        self.image = image
    }
    
    
}
    
