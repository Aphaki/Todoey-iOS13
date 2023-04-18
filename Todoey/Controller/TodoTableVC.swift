//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoTableVC: UITableViewController {
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            
        }
    }
    
    var toDoContents: Results<Content>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = self.toDoContents?[indexPath.row].title ?? "None"
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = self.toDoContents?[indexPath.row].title ?? "None"
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
        if let selectedObject =
            toDoContents?[indexPath.row] {
            do {
                try realm.write {
                    selectedObject.isChecked.toggle()
                }
            } catch {
                print("TodoTableVC - check error")
            }
            
        }
        tableView.reloadData()
    }
    
    //MARK: - Plus btn action
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Todo", message: "Add Todo Content", preferredStyle: .alert)
        alert.addTextField { tf in
            textField = tf
            textField.placeholder = "Type your Todo"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            if let validCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let aContent = Content()
                        aContent.title = textField.text!
                        aContent.createdDate = Date()
                        validCategory.contents.append(aContent)
                    }
                } catch {
                    print("TodoTableVC - addBtnPressed() - Add error: \(error)")
                }
            }
        } //action
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

extension TodoTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

