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
                if let results = self?.parseSearchResults(data) {
                    self?.delegate?.updateSearchResults(results)
                }
            }
        })
        
        dataTask?.resume()
    }
    
    private func parseSearchResults(_ data: Data)-> [MainVC.PlaceResult] {
        print("updateSearchResults")
        
        var results: [MainVC.PlaceResult] = []
        var response: [String: Any]?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let parseError as NSError {
            errorMessage = "JSONSerialization error: \(parseError.localizedDescription)\n"
            return []
        }
        
        guard let geonames = response!["geonames"] as? [[String: Any]] else {
            errorMessage = "Error parsing\n"
            return []
        }
        
        for place in geonames {
            guard let title = place["title"] as? String else {
                errorMessage = "Error parsing the title\n"
                return []
            }
            guard let summary = place["summary"] as? String else {
                errorMessage = "Error parsing the summary\n"
                return []
            }
            let imageUrl = place["thumbnailImg"] as? String
            
            print("title=\(title), summary=\(summary)" )
            results.append(MainVC.PlaceResult(title: title, summary: summary, imageUrl: imageUrl))
        }
        
        print("Done parsing")
        return results
    }
}
