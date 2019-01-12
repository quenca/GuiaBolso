//
//  DataSource.swift
//  GuiaBolso
//
//  Created by Gustavo Quenca on 03/01/19.
//  Copyright © 2019 Quenca. All rights reserved.
//

import Foundation
class DataSource {
    // MARK: -Properties
    typealias Completion = (Bool) -> Void
    
    enum State {
        case loading
        case noResults
        case results([String])
    }
    
    enum StateCategory {
        case loading
        case noResults
        case categoryResults(CategoryDetail)
    }
    
    private(set) var state: State = .loading
    private(set) var categoryState: StateCategory = .loading
    
    var dataTask: URLSessionDataTask? = nil
    
    // MARK: -URL
    func getURL () -> URL {
        let urlString = "https://api.chucknorris.io/jokes/categories"
        let url = URL(string: urlString)
        print(url!)
        return url!
    }
    
    func getCategoryURL(category: String) -> URL {
        
        let encodedText = category.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let urlString = "https://api.chucknorris.io/jokes/random?category=\(encodedText)"
        
        let url = URL(string: urlString)
        return url!
    }
    
    // MARK: -Parses
    func parse(data: Data) -> [String]? {
        do {
            let decoder = JSONDecoder();
            let result = try decoder.decode(Array<String>.self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    func parseCategory(data: Data) -> CategoryDetail? {
        do {
            let decoder = JSONDecoder();
            let result = try decoder.decode(CategoryDetail.self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    // MARK: -Requests
    func getRequest(completion: @escaping Completion) {
        
        let url = getURL()
        let session = URLSession.shared
        
        state = .loading
        
        dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
            var success = false
            var newState = State.noResults
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                
                let category = self.parse(data: data)
                if category == nil {
                    newState = State.noResults
                } else {
                    newState = .results(category!)
                }
                success = true
            }
            DispatchQueue.main.async {
                self.state = newState
                completion(success)
            }
        })
        dataTask?.resume()
    }
    
    func getCategoryRequest(for text: String, completion: @escaping Completion) {
        if !text.isEmpty {
            dataTask?.cancel()
            
            categoryState = .loading
            
            let url = getCategoryURL(category: text)
            let session = URLSession.shared
            dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
                var success = false
                var newState = StateCategory.noResults
                
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    
                    let searchResults = self.parseCategory(data: data)
                    
                    if let searchResults = searchResults {
                        newState = .categoryResults(searchResults)
                    } else {
                        newState = StateCategory.noResults
                    }
                    
                    success = true
                }
                
                DispatchQueue.main.async {
                    self.categoryState = newState
                    completion(success)
                    
                }
            })
            dataTask?.resume()
        }
    }
}
