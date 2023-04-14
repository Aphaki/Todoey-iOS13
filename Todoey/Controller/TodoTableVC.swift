//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//
//        TodoContext(body: "Use UITableViewController", isChecked: false),
//        TodoContext(body: "Use UserDefaults In UIKit", isChecked: false),
//        TodoContext(body: "Use Core Data In UIKit", isChecked: true),
//        TodoContext(body: "Use realm In UIKit", isChecked: false),
//        TodoContext(body: "Use UITableViewController", isChecked: false)

import UIKit
import RealmSwift

class TodoTableVC: SwipTableVC {
    
    var toDoContents: Results<Content>?
    
    var selectedCategory: Category? {
        didSet {
            loadContents()
        }
    }

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - Manipulation Method
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Todo", message: "Do you add Todo Contents?", preferredStyle: .alert)
        
        alert.addTextField { tf in
            tf.placeholder = "Type and Add"
            textField = tf
            print("textField text: \(textField.text ?? "none")")
        }
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            try? self.realm.write {
                let aContent = Content()
                aContent.title = textField.text!
                self.selectedCategory?.contents.append(aContent)
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    override func deleteModel(indexPath: IndexPath) {
        if let selectedContent = toDoContents?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(selectedContent)
                }
            } catch {
                print("TodoTableVC - delete content error: \(error)")
            }
        }
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = self.toDoContents?[indexPath.row].title
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = self.toDoContents?[indexPath.row].title
        }
        
        if toDoContents?[indexPath.row].isChecked == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoContents?.count ?? 1
    }
    
    
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCell = tableView.cellForRow(at: indexPath)
        do {
            try realm.write {
                toDoContents?[indexPath.row].isChecked.toggle()
            }
        } catch {
            print("ToDo Toggle error: \(error)")
        }
        
        
        tableView.reloadData()
    }
    
    func loadContents() {
        toDoContents = selectedCategory?.contents.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

extension TodoTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}


