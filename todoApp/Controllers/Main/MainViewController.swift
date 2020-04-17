//
//  MainViewController.swift
//  todoApp
//
//  Created by Alessandro Schioppetti on 14/04/2020.
//  Copyright © 2020 Codermine Srl. All rights reserved.
//

import UIKit
import SwipeCellKit

class MainViewController: BaseViewController {
    
    var todos = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        title = "TODOList"
        navigationController?.navigationBar.barTintColor = .blue
        let addButton = UIBarButtonItem(image: .add,
                                        style: .plain,
                                        target: self,
                                        action: #selector(addButtonTouchUp(_:)))
        navigationItem.rightBarButtonItems = [addButton]
        todoTableView.dataSource = self
        todoTableView.delegate = self
        //todoTableView.registerNib(TodoListTableViewCell.self)
        todoTableView.registerClass(SwipeTableViewCell.self)
        
    }
    
    @objc
    func addButtonTouchUp(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let textFields = alert.textFields {
                let newItem = Item()
                newItem.title = textFields[0].text!
                self.todos.append(newItem)
                self.saveItems()
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showError(_ errorMessgae: String) {
        let alert = UIAlertController(title: "Error", message: errorMessgae, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        PlistService.shared.saveItems(self.todos, self.dataFilePath!) { errorMessage in
            if errorMessage != nil {
                self.showError(errorMessage!)
            } else {
                self.todoTableView.reloadData()
            }
        }
    }
    
    
    func loadItems() {
        PlistService.shared.loadItems(dataFilePath!) { result in
            switch result {
            case .success(let todos):
                self.todos = todos
                self.todoTableView.reloadData()
            case .failure(let error):
                self.showError(error.localizedDescription)
            }
        }
    }
    
    
}

//MARK: - todoTableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueClass(SwipeTableViewCell.self, for: indexPath)
        let item = todos[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        cell.delegate = self
        return cell
        
    }
    
}

//MARK: - todoListViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(#function)
        tableView.deselectRow(at: indexPath, animated: true)
        todos[indexPath.row].done = !todos[indexPath.row].done
        PlistService.shared.saveItems(todos, dataFilePath!) { messageError in
            if messageError != nil {
                self.todos[indexPath.row].done = !self.todos[indexPath.row].done
                self.showError(messageError!)
            } else {
                self.todoTableView.reloadData()
            }
        }
        
    }
    
}

//MARK: - SwipeTableViewCellDelegate

extension MainViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.todos.remove(at: indexPath.row)
            self.saveItems()
            print("deleted somthing")
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        print(#function)
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
}


