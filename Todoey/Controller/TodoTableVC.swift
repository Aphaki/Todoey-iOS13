//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoTableVC: UITableViewController {
    
    var myToDoContext: [TodoContext] = [
        TodoContext(body: "Use UITableViewController", isChecked: false),
        TodoContext(body: "Use UserDefaults In UIKit", isChecked: false),
        TodoContext(body: "Use Core Data In UIKit", isChecked: true),
        TodoContext(body: "Use realm In UIKit", isChecked: false),
        TodoContext(body: "Use UITableViewController", isChecked: false)
    ]
//    let defaults = UserDefaults.standard
    
    @IBAction func pressedBarBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New content", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "add", style: .default) { _ in
            self.myToDoContext.append(TodoContext(body: textField.text ?? ""))
            self.tableView.reloadData()
        }
        alert.addTextField { tf in
            tf.placeholder = "write to do"
            textField = tf
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true)
        
    }
    let fileManagerPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathExtension("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = self.myToDoContext[indexPath.row].body
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = self.myToDoContext[indexPath.row].body
        }
        
        if myToDoContext[indexPath.row].isChecked == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myToDoContext.count
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myToDoContext[indexPath.row].isChecked.toggle()
        tableView.reloadData()
    }
    
    //MARK: - UserDefaults method
    func saveData() {
        
    }
    
}

