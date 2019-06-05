//
//  ViewController.swift
//  ToDo App
//
//  Created by Pamela Wang on 4/6/19.
//  Copyright © 2019 Pamela Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Testing Data Management
        let todoItem = ToDoItem(title: "First ToDo", completed: false, createdAt: Date(), itemIdentifier: UUID())
        todoItem.saveItem()
        
        let todos = DataManager.loadAll(ToDoItem.self)
        print(todos)
    }


}

