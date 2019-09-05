//
//  LocalSearch.swift
//  WikipediaExercise
//
//  Created by Iris Ronen on 9/5/19.
//  Copyright © 2019 Iris Ronen. All rights reserved.
//

import Foundation

class LocalSearch {
    var delegate: SearchProtocol?
    var errorMessage: String?
    
    func search(forText text: String) {
        let results = CoreDataModelForSearch().readSearchResultsFromCoreData(forText: text)
        delegate?.updateSearchResults(results)
    }
}
