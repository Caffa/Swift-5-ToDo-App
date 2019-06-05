//
//  ToDoItem.swift
//  ToDo App
//
//  Created by Pamela Wang on 6/6/19.
//  Copyright © 2019 Pamela Wang. All rights reserved.
//

import Foundation

struct ToDoItem : Codable {
    var title:String
    var completed:Bool
    var createdAt:Date
    var itemIdentifier:UUID
    
    func saveItem(){
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
    func deleteItem(){
        DataManager.delete(itemIdentifier.uuidString)
    }
    
    mutating func markAsComplete(){
        self.completed = true
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
    //DIY
    mutating func updateItem(_ newTitle: String){
        self.title = newTitle
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
}
