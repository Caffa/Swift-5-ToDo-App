//
//  ToDoTableViewController.swift
//  ToDo App
//
//  Created by Pamela Wang on 6/6/19.
//  Copyright © 2019 Pamela Wang. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController  {

    
    @IBOutlet weak var progressBar: UIProgressView!
    
    //    var todoItems:[ToDoItem]!
    var todoItems:[ToDoItem]! {
        didSet{
            progressBar.setProgress(progress, animated: true)
        }
    }
    
    var progress:Float {
        if todoItems.count > 0 {
            return Float(todoItems.filter({$0.completed}).count) / Float(todoItems.count)
        }else{
            return 0
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    func addNewTodo() {
        let addAlert = UIAlertController(title: "New ToDo!", message: "Enter a Title", preferredStyle: .alert)
        addAlert.addTextField {(textfield:UITextField) in
            textfield.placeholder = "ToDo Item Title"
        }
        
        addAlert.addAction(UIAlertAction(title: "Create", style: .default , handler: {(action:UIAlertAction) in
            
            guard let title = addAlert.textFields?.first?.text else {return}
            let newTodo = ToDoItem(title: title, completed: false, createdAt: Date(), itemIdentifier: UUID())
            newTodo.saveItem()
            
            self.todoItems.append(newTodo)
            
            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
            
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
//            print("New ToDo Added")
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(addAlert, animated: true, completion: nil)
    }
    

   
    func getUpdatedToDo(_ oldTitle:String) {
        let addAlert = UIAlertController(title: "Modified ToDo!", message: "Enter a Title", preferredStyle: .alert)
        addAlert.addTextField {(textfield:UITextField) in
            textfield.placeholder = oldTitle
        }
        
        addAlert.addAction(UIAlertAction(title: "Create", style: .default , handler: {(action:UIAlertAction) in
            
            guard let title = addAlert.textFields?.first?.text else {return}
            let newTodo = ToDoItem(title: title, completed: false, createdAt: Date(), itemIdentifier: UUID())
            newTodo.saveItem()
            
            self.todoItems.append(newTodo)
            
            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
            
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
            //            print("New ToDo Added")
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(addAlert, animated: true, completion: nil)
    }
    


    func completeTodoItem(_ indexPath:IndexPath) {
        var todoItem = todoItems[indexPath.row]
        todoItem.markAsComplete()
        todoItems[indexPath.row] = todoItem
        
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell {
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = cell.transform.scaledBy(x: 1.5, y: 1.5)
                
            }, completion: { (success) in
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
                                   options: .curveEaseOut, animations: {
                        cell.transform = CGAffineTransform.identity
                    }, completion: nil)
            }
                
            
            
            )
        }

    }
    
    //optional way of showing completed
    func strikeThroughText(_ text:String) -> NSAttributedString{
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    
    func loadData(){
        // init todo items array
        todoItems = [ToDoItem]()
        //sort elements
        todoItems = DataManager.loadAll(ToDoItem.self).sorted(by: {
            //first element n second element
            $0.createdAt < $1.createdAt
            })
        //reload table view since now have data
        tableView.reloadData()
        progressBar.setProgress(progress, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoTableViewCell
        
//        cell.delegate = self

        // Configure the cell...
        let todoItem = todoItems[indexPath.row]
        cell.todoLabel.text = todoItem.title
        
        //optional way of showing completed - strikethrough when load
        if todoItem.completed{
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
        }
        
        

        return cell
    }
    
//    func focusTodo(_ todoItem:ToDoItem){
//        //TODO: focus (e.g. make this a main) - edit
//        //make a text pop up
//
//        // edit
//
//        print("Focusing on")
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let focusAction = UITableViewRowAction(style: .normal, title: "Edit" ) {
            (action:UITableViewRowAction, indexPath: IndexPath) in
            let todoItem = self.todoItems[indexPath.row]
            //TODO: get input
            let originalText = todoItem.title
            self.getUpdatedToDo(originalText)
            self.todoItems[indexPath.row].deleteItem()
            self.todoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

        }
        focusAction.backgroundColor = UIColor(named: "accentRed")
        
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete"){ (action:UITableViewRowAction, indexPath:IndexPath) in
            self.todoItems[indexPath.row].deleteItem()
            self.todoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = UIColor(named: "accentBlue")
        return [deleteAction, focusAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeTodoItem(indexPath)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
