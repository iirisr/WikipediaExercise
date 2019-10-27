//
//  SearchProtocol.swift
//  WikipediaExercise
//
//  Created by Iris Ronen on 9/5/19.
//  Copyright © 2019 Iris Ronen. All rights reserved.
//

import UIKit

protocol SearchProtocol {
    func updateSearchResults(_ results: [MainVC.PlaceResult])
}
