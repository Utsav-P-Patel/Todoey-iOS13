//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    var selectedCatagory: Category? {
        didSet{
            loadItems()
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Table view Datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel!.text = item.title
            cell.accessoryType = item.done ?  .checkmark : .none
        } else {
            cell.textLabel!.text = "No items added"
        }
        return cell
    }
    
    //MARK: - Tableview Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //What will happen once the user clicks the Add Item Button on our UIAlert
            if let currentCategory = self.selectedCatagory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving items, \(error)")
                }
            }
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model manipulation methods
    
    func loadItems() {
        
        todoItems = selectedCatagory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

    
}


//MARK: - Search bar methods


extension ToDoListViewController: UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = selectedCatagory?.items.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            todoItems = selectedCatagory?.items.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
}
