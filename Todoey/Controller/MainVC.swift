//
//  MainVC.swift
//  Todoey
//
//  Created by Sy Lee on 2023/04/19.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UITableViewController {
    
    var categories: [Category] = []
    
    var selectedCategory: Category?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = categories[indexPath.row].title
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = categories[indexPath.row].title
        }
        
        return cell
    }
    
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToContentsVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ContentsVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC?.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    
    //MARK: - Update Model
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Category", message: "Add your Todo Category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            let aCategory = Category(context: self.context)
            aCategory.title = textField.text
            self.categories.append(aCategory)
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addTextField { tf in
            textField = tf
            textField.placeholder = "Typing.."
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    func saveData() {
        do {
            try context.save()
        } catch {
            print("MainVC - saveData() error : \(error)")
        }
        
    }
    
    func loadData() {
        let request = NSFetchRequest<Category>(entityName: "Category")
        
        do {
            self.categories = try context.fetch(request)
        } catch {
            print("MainVC - loadData() - error: \(error) ")
        }
        tableView.reloadData()
    } // loadData()
    
    
    
}
