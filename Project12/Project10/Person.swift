//
//  Person.swift
//  Project12
//
//  Created by Linix on 2017/2/28.
//  Copyright © 2017年 Linix. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    // 为继承 NSCoding，必须加上下面的 init 和 encode()
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        image = aDecoder.decodeObject(forKey: "image") as! String
    }

    func encode(with aCoder: NSCoder) {             // for saving data
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
