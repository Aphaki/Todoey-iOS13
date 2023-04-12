//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoTableVC: UITableViewController {
    
    var toDoContents: [Content] = [
//        TodoContext(body: "Use UITableViewController", isChecked: false),
//        TodoContext(body: "Use UserDefaults In UIKit", isChecked: false),
//        TodoContext(body: "Use Core Data In UIKit", isChecked: true),
//        TodoContext(body: "Use realm In UIKit", isChecked: false),
//        TodoContext(body: "Use UITableViewController", isChecked: false)
    ]

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
            content.text = self.toDoContents[indexPath.row].title
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = self.toDoContents[indexPath.row].title
        }
        
        if toDoContents[indexPath.row].isChecked == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoContents.count
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCell = tableView.cellForRow(at: indexPath)
        toDoContents[indexPath.row].isChecked.toggle()
        tableView.reloadData()
    }
}

extension TodoTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

