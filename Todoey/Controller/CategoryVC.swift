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

    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = categories?[indexPath.row].title ?? "Category is empty"
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = categories?[indexPath.row].title ?? "Category is empty"
        }
        return cell
    }

    //MARK: - Data manipulation methods
    
    // Create
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Category", message: "Type the Category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { _ in
           
            if let addCategoryTitle = textField.text {
                let aCategory = Category()
                aCategory.title = addCategoryTitle
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
    // Read --> Dynamic var
    
    // Update
    
    // Delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, contextualView, success: @escaping (Bool) -> Void) in
            if let categoryDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryDeletion)
                    }
                } catch {
                    print("Categoty swipe delete error: \(error)")
                }
                
            }
            
            print("Swip Delete Pressed")
            tableView.reloadData()
            success(true)
           
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
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
    
    func loadCategories() {
        self.categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
