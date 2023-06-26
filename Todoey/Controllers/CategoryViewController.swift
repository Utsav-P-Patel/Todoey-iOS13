//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Utsav Patel on 17/06/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    var categoryItemArray: Results<Category>?

    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }


    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = categoryItemArray?[indexPath.row].name ?? "No Categories Added yet"
        
        return cell
    }
    
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textValue = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "Items can be added to categories", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textValue.text!
            self.save(category: newCategory)
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Enter category here"
            textValue = textField
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                    
            performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatagory = categoryItemArray?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categoryItemArray = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
}
