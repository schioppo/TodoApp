//
//  PlistService.swift
//  todoApp
//
//  Created by Alessandro Schioppetti on 16/04/2020.
//  Copyright © 2020 Codermine Srl. All rights reserved.
//

import Foundation

typealias saveCompletion = (_ msgError: String?) -> Void
typealias loadCompletion = (Result<[Item], Error>) -> Void

class PlistService {
    
    static let shared: PlistService = PlistService()
    
    func saveItems(_ todos: [Item], _ dataFilePath: URL, completion: @escaping saveCompletion) {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(todos)
            try data.write(to: dataFilePath)
            DispatchQueue.main.async {
                completion(nil)
                
            }
        } catch {
            DispatchQueue.main.sync {
                completion("error during saving items")
            }
            
        }
        
    }
    
    func loadItems(_ dataFilePath: URL, completion: @escaping loadCompletion) {
        
        if let data = try? Data(contentsOf: dataFilePath) {
            let decoder = PropertyListDecoder()
            do {
                let todos = try decoder.decode([Item].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(todos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
    }
    
}
