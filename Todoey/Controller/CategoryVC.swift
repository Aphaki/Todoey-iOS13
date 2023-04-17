//
//  CategoryVC.swift
//  Todoey
//
//  Created by Sy Lee on 2023/04/12.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: SwipeTableVC {

    var categories: Results<Category>? {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        return categories?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = categories?[indexPath.row].title ?? "Category is Empty"
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = categories?[indexPath.row].title ?? "Category is Empty"
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
                var aCategory = Category()
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
    
    // Read
    func loadFromRealm() {
       categories = realm.objects(Category.self)
    }
    
    
    // Update
    
    // Delete: SwipeTableVC에서 선언
    override func updateModel(indexPath: IndexPath) {
        if let selectedCategory = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(selectedCategory)
                }
            } catch {
                print("CategoryVC - updateModel() error: \(error)")
            }
        }
    }
    
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToTodoView", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoTableVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}
