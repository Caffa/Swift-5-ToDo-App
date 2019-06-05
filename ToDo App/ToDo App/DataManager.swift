//
//  DataManager.swift
//  ToDo App
//
//  Created by Pamela Wang on 6/6/19.
//  Copyright © 2019 Pamela Wang. All rights reserved.
//

import Foundation


public class DataManager{
    //Get document directory
    static fileprivate func getDocumentDirectory() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            return url
        }else{
            fatalError("Unable to access document directory")
        }
    }
    
    //Save any codable objects (e.g. toDoItem)
    static func save <T:Encodable> (_ object:T, with fileName: String){
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path){
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    
    
    //Load any codable objects (e.g. toDoItem)
    static func load <T:Decodable> (_ fileName:String, with type:T.Type) -> T {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path){
            fatalError("File not found at path: \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path){
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        }else{
            fatalError("Data unavailable at path: \(url.path)")
        }
    }
    
    //Load Data from File - without converting into a model object
    static func loadData (_ fileName:String) -> Data? {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path){
            fatalError("File not found at path: \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path){
            return data
        }else{
            fatalError("Data unavailable at path: \(url.path)")
        }
    }
    
    
    
    //Load all files from Directory
    static func loadAll <T:Decodable> (_ type:T.Type) -> [T]{
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            
            var modelObjects = [T]()
            
            for fileName in files {
                modelObjects.append(load(fileName, with: type))
            }
            
            return modelObjects
        }catch{
            fatalError("Couldn't load all files")
        }
    }
    
    //Delete a file
    static func delete (_ fileName:String){
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        if FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.removeItem(at: url)
            }catch{
                fatalError(error.localizedDescription)
            }
        }
    }
}
