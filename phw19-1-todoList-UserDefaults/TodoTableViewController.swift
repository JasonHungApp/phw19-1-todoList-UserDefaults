//
//  todoTableViewController.swift
//  phw19-1-todoList-UserDefaults
//
//  Created by jasonhung on 2024/1/7.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    var todos = [Todo](){
        didSet {
            Todo.saveTodos(todos)
        }
    }
    
    var incompleteTodos: [Todo] {
        return todos.filter { !$0.isCompleted }
    }
    
    var completedTodos: [Todo] {
        return todos.filter { $0.isCompleted }
    }
    
    var selectTodoIndex = -1
    
    
    
    @IBAction func unwindToTodoTableView(_ unwindSegue: UIStoryboardSegue) {
        print("TodoTableViewController - func unwindToTodoTableView")
        if let sourceViewController = unwindSegue.source as? EditTodoTableViewController,
           let todo = sourceViewController.todo{
            print(todo)
            
            if !todo.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                
                if selectTodoIndex > -1 {
                    todos[selectTodoIndex] = todo
                   // tableView.reloadRows(at: [indexPath], with: .automatic)
                }else{
                    todos.insert(todo, at: 0)
                    //let indexPath = IndexPath(row: 0, section: 0)
                    //tableView.insertRows(at: [indexPath], with: .automatic)
                }
                selectTodoIndex = -1
                tableView.reloadData()
            }
        }
    }
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg") )
        tableView.backgroundView?.alpha = 0.5
        
        
        if let todos = Todo.loadTodos(){
            self.todos = todos
            print(self.todos)
        }
        
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedTodo = indexPath.section == 0 ? incompleteTodos[indexPath.row] : completedTodos[indexPath.row]
        
        let actionTitle = indexPath.section == 0 ? "已完成" : "Delete"
        let actionColor = indexPath.section == 0 ? UIColor(red: 51/255, green: 153/255, blue: 0, alpha: 1) : UIColor.red
        
        let contextualAction = UIContextualAction(style: .normal, title: actionTitle) { (_, _, completionHandler) in
            if indexPath.section == 0 {
                // Your completion action logic for "已完成"
                // Mark the task as completed
                if let index = self.todos.firstIndex(of: selectedTodo) {
                    self.todos[index].isCompleted = true
                    
                    print(self.todos[index])
                }
            } else {
                // Your delete action logic for "Delete"
                // Remove the task
                if let index = self.todos.firstIndex(of: selectedTodo) {
                    self.todos.remove(at: index)
                }
            }
            
            // Reload the entire table view after the action
            tableView.reloadData()
            
            // Call the completion handler to signal that the action was performed
            completionHandler(true)
        }
        
        contextualAction.backgroundColor = actionColor  // Customize the background color
        
        let configuration = UISwipeActionsConfiguration(actions: [contextualAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentTodos = indexPath.section == 0 ? todos.filter { !$0.isCompleted } : todos.filter { $0.isCompleted }
            let selectedTodo = currentTodos[indexPath.row]
            
            if indexPath.section == 0 {
                // 刪除未完成的任務，將其標記為已完成
                if let index = todos.firstIndex(of: selectedTodo) {
                    todos[index].isCompleted = true
                }
            } else {
                // 刪除已完成的任務，真的刪除
                if let index = todos.firstIndex(of: selectedTodo) {
                    todos.remove(at: index)
                }
            }
            
            // 保存更新後的任務列表
            Todo.saveTodos(todos)
            tableView.reloadData()
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return todos.filter { !$0.isCompleted }.count
        } else {
            return todos.filter { $0.isCompleted }.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
        
        if section == 0 {
            titleLabel.text = "未完成"
        } else {
            titleLabel.text = "已完成"
        }
        
        return headerView
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell", for: indexPath)
        
        let currentTodos = indexPath.section == 0 ? todos.filter { !$0.isCompleted } : todos.filter { $0.isCompleted }
        let currentTodo = currentTodos[indexPath.row]
        
        // Configure your cell with the currentTodo data
        cell.textLabel?.text = currentTodo.title
        cell.detailTextLabel?.text = currentTodo.note
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        // 如果是已完成的 section，不允許點擊
//        return indexPath.section == 0
//    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("TodoTableViewController - func prepare")
        
        
        if let editTodoController = segue.destination as? EditTodoTableViewController,
           let selectedIndexPath = tableView.indexPathForSelectedRow {
            
            let selectedTodo: Todo
            if selectedIndexPath.section == 0 {
                selectedTodo = incompleteTodos[selectedIndexPath.row]
            } else {
                selectedTodo = completedTodos[selectedIndexPath.row]
            }
            
            self.selectTodoIndex=self.todos.firstIndex(of: selectedTodo)!

            editTodoController.todo = selectedTodo
            
            tableView.reloadData() // 消除 indexPathForSelectedRow = nil
        }
    }
    
    
}
