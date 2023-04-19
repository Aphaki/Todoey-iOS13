//
//  ContentsVC.swift
//  Todoey
//
//  Created by Sy Lee on 2023/04/19.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ContentsVC: UITableViewController {

    var selectedCategory: Category?
    
    var contents: [Content] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath)
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = contents[indexPath.row].body
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = contents[indexPath.row].body
        }
        if contents[indexPath.row].isChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func loadData() {
        let request = NSFetchRequest<Content>(entityName: "Content")
        request.predicate = NSPredicate(format: "parentCategory.title", selectedCategory!.title!)
        do {
            self.contents = try context.fetch(request)
        } catch {
            print("ContentsVC - loadData() error: \(error)")
        }
        
        
    }
}
