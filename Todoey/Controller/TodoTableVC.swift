//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoTableVC: UITableViewController {
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathExtension("Item.plist")
    
    var myToDoContext: [TodoContext] = [
//        TodoContext(body: "Use UITableViewController", isChecked: false),
//        TodoContext(body: "Use UserDefaults In UIKit", isChecked: false),
//        TodoContext(body: "Use Core Data In UIKit", isChecked: true),
//        TodoContext(body: "Use realm In UIKit", isChecked: false),
//        TodoContext(body: "Use UITableViewController", isChecked: false)
    ]
//    let defaults = UserDefaults.standard
    
    @IBAction func pressedBarBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New content", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "add", style: .default) { _ in
            self.myToDoContext.append(TodoContext(body: textField.text ?? ""))
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addTextField { tf in
            tf.placeholder = "write to do"
            textField = tf
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
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
        saveData()
        tableView.reloadData()
    }
    
    //MARK: - persistant Data method
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
           let data = try encoder.encode(self.myToDoContext)
           try data.write(to: filePath)
        } catch let error {
            print("Encoded Error \(error)")
        }
    }
    func loadData() {
        let deconder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: filePath)
            let decodedData = try deconder.decode([TodoContext].self, from: data)
            self.myToDoContext = decodedData
            
        } catch let error {
            print("data Decoding error, \(error)")
        }
        
    }
    
}

