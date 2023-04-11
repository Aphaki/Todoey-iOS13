//
//  CategoryTableVC.swift
//  Todoey
//
//  Created by Sy Lee on 2023/04/10.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableVC: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCoreData()
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Category", message: "Add your Category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            let aCategory = Category(context: self.context)
            aCategory.name = textField.text
            self.categories.append(aCategory)
            self.saveCoreData()
            self.tableView.reloadData()
        }
        alert.addTextField { tf in
            textField =  tf
            print("Add Category - textField: \(textField.text ?? "")")
        }
        alert.addAction(action)
        present(alert, animated: true)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryReusableCell", for: indexPath)
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = categories[indexPath.row].name
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = categories[indexPath.row].name
        }
        
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemView", sender: self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoTableVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }

    //MARK: - Core Data Methods
    func saveCoreData() {
        do {
            try context.save()
        } catch let error {
            print("CategoryTableVC - saveCoreData error occured : \(error)")
        }
    }
    
    func loadCoreData() {
        let request = NSFetchRequest<Category>(entityName: "Category")
        do {
            self.categories = try context.fetch(request)
        } catch let error {
            print("CategoryTableVC - loadCoreData() error occured : \(error)")
        }
        tableView.reloadData()
    }
    
    
    

}

extension CategoryTableVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.predicate = predicate
        do {
            try self.categories = context.fetch(request)
        } catch let error {
            print("CategoryTableVC - searchBarSearchButtonClicked() - fetch error : \(error)")
        }
        tableView.reloadData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadCoreData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
