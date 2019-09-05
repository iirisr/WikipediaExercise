//
//  WikipediaSearch.swift
//  WikipediaExercise
//
//  Created by Iris Ronen on 9/5/19.
//  Copyright © 2019 Iris Ronen. All rights reserved.
//

import Foundation

class WikipediaSearch {
    var delegate: SearchProtocol?
    var errorMessage: String?
    
    func search(forText text: String) {
        let session = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        let place = text.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "http://api.geonames.org/wikipediaSearchJSON?q=" + place + "&maxRows=10&username=tingz")
        
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: url!, completionHandler: { [weak self] data, response, error in
            defer {
                dataTask = nil
            }
            if let error = error {
                self?.errorMessage = "DataTask error: " + error.localizedDescription
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self?.delegate?.updateSearchResults(data)
            }
        })
        
        dataTask?.resume()
    }
}
