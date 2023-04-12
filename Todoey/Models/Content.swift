//
//  Content.swift
//  Todoey
//
//  Created by Sy Lee on 2023/04/12.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Content: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isChecked: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "contents")
    
    
//    init(title: String, isChecked: Bool = false) {
//        self.title = title
//        self.isChecked = isChecked
//    }
}

