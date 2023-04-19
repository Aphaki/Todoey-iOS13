//
//  SwipTableVC.swift
//  Todoey
//
//  Created by Sy Lee on 2023/04/14.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit

class SwipTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        return cell
    }

    
    // MARK: - Swip Actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, contextualView, success: @escaping (Bool) -> Void) in
            self.deleteModel(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            success(true)
        }
        delete.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteModel(indexPath: IndexPath) {
        
    }
    

}
