//
//  TodoContext.swift
//  Todoey
//
//  Created by Sy Lee on 2023/04/06.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct TodoContext {
    let body: String
    var isChecked: Bool
    
    init(body: String, isChecked: Bool = false) {
        self.body = body
        self.isChecked = isChecked
    }
}
