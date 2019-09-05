//
//  SearchProtocol.swift
//  WikipediaExercise
//
//  Created by Iris Ronen on 9/5/19.
//  Copyright © 2019 Iris Ronen. All rights reserved.
//

import UIKit

protocol SearchProtocol {
    func updateSearchResults(_ data: Data)
    func updateSearchResults(_ results: [MainVC.PlaceResult])
}

extension SearchProtocol {
    
    func updateSearchResults(_ data: Data) {
        //this is a empty implementation to allow this method to be optional
    }
    
    func updateSearchResults(_ results: [MainVC.PlaceResult]) {
        //this is a empty implementation to allow this method to be optional
    }
}
