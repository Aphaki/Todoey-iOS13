//
//  ContentsVC.swift
//  Todoey
//
//  Created by Sy Lee on 2023/04/19.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ContentsVC: UITableViewController {

    var selectedCategory: Category? {
        didSet {
            loadCoreData()
        }
    }
    
    var contents: [Content] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath)
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = contents[indexPath.row].body
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = contents[indexPath.row].body
        }
        if contents[indexPath.row].isChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contents[indexPath.row].isChecked.toggle()
        saveCoreData()
        tableView.reloadData()
    }
    
    
    //MARK: - Add
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add", message: "Add a Content", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            let aContent = Content(context: self.context)
            aContent.body = textField.text
            aContent.parentCategory = self.selectedCategory
            aContent.date = Date()
            aContent.isChecked = false
            self.contents.append(aContent)
            self.saveCoreData()
            self.tableView.reloadData()
        }
        alert.addTextField { tf in
            textField = tf
            textField.placeholder = "Type..."
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Save
    func saveCoreData() {
        do {
            try context.save()
        } catch {
            print("ContentsVC - saveData() error: \(error)")
        }
    }
    //MARK: - Load
    func loadCoreData() {
        let request = NSFetchRequest<Content>(entityName: "Content")
        let predicate = NSPredicate(format: "parentCategory.title MATCHES[cd] %@", selectedCategory!.title!)
        request.predicate = predicate
        do {
            self.contents = try context.fetch(request)
        } catch {
            print("ContentsVC - loadCoreData() error: \(error)")
        }
        tableView.reloadData()
    }
    
}
