//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//
/*
 TodoContext(body: "Use UITableViewController", isChecked: false),
 TodoContext(body: "Use UserDefaults In UIKit", isChecked: false),
 TodoContext(body: "Use Core Data In UIKit", isChecked: true),
 TodoContext(body: "Use realm In UIKit", isChecked: false)
 */

import UIKit
import CoreData

class TodoTableVC: UITableViewController {
    
    var myTodoContents: [Content] = []
    
    var selectedCategory: Category? {
        didSet {
            loadCoreData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory?.name
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Core Data methods
    func saveInCoreData() {
        do {
            try context.save()
        } catch let error {
            print("saveInCoreData() error occured : \(error)")
        }
        
    }
    
    func loadCoreData(with request: NSFetchRequest<Content> = Content.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
    
        do {
            myTodoContents = try context.fetch(request)
        } catch let error {
            print("loadCoreData() error occured: \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo content", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            let newContent = Content(context: self.context)
            newContent.text = textField.text
            newContent.isChecked = false
            newContent.parentCategory = self.selectedCategory
            self.myTodoContents.append(newContent)
            print(textField.text ?? "")
            self.saveInCoreData()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        
        alert.addTextField { tf in
            tf.placeholder = "Write to do"
            textField = tf
        }
        
        present(alert, animated: true)
    }
    
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = self.myTodoContents[indexPath.row].text
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = self.myTodoContents[indexPath.row].text
        }
        
        if myTodoContents[indexPath.row].isChecked == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTodoContents.count
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTodoContents[indexPath.row].isChecked.toggle()
        saveInCoreData()
        tableView.reloadData()
    }
}

extension TodoTableVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!)
        loadCoreData(predicate: predicate)
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadCoreData()
        }
    }
}

