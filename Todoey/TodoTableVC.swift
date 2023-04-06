//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoTableVC: UITableViewController {
    
    var myToDoContext: [String] = [
    "Use UITableViewController",
    "Use UserDefaults In UIKit",
    "Use Core Data In UIKit",
    "Use realm In UIKit"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: .default, reuseIdentifier: "TodoListContext")
        
        return
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myToDoContext.count
    }


}

