//
//  CategoryVC.swift
//  Todoey
//
//  Created by Sy Lee on 2023/04/12.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: UITableViewController {

    var categories = Array<Category>()
    
    let realm = try! Realm()
    
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
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = categories[indexPath.row].title
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = categories[indexPath.row].title
        }
        
        return cell
    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Category", message: "Type the Category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { _ in
           
            if let addCategoryTitle = textField.text {
                var aCategory = Category()
                aCategory.title = addCategoryTitle
                self.categories.append(aCategory)
                self.saveInRealm(addCategory: aCategory)
            }
        }
        alert.addTextField { tf in
            textField = tf
            print(textField.text ?? "none")
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    func saveInRealm(addCategory: Object) {
        do {
            try realm.write {
                realm.add(addCategory)
            }
        } catch let error {
            print("Realm save error : \(error)")
        }
        self.tableView.reloadData()
    }
}
