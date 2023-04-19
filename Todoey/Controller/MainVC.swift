//
//  MainVC.swift
//  Todoey
//
//  Created by Sy Lee on 2023/04/19.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit

class MainVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    //MARK: - Update Model
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
    }
    
    
}
