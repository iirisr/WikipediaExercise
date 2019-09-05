//
//  coreDataModelForSearch.swift
//  WikipediaExercise
//
//  Created by Iris Ronen on 9/5/19.
//  Copyright © 2019 Iris Ronen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataModelForSearch {
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    func saveToCoreData(text: String, searchResults: [MainVC.PlaceResult]) {
        let context = container!.viewContext
        
        let searchDB = Search(context: context)
        searchDB.text = text
        
        for place in searchResults {
            let placeDB = Place(context: context)
            placeDB.title = place.title
            placeDB.summary = place.summary
            placeDB.image = place.imageUrl
            
            searchDB.addToPlaces(placeDB)
            
        }
        
        do {
            try context.save()
            print("Saved \(searchDB.text) to CoreData")
        }
        catch {
            print("Error saving to CoreData")
        }
        
        print("All search for \(text) was loaded")
    }
    
    func readSearchResultsFromCoreData(forText text: String) -> [MainVC.PlaceResult] {
        let context = container!.viewContext
        
        var rc = [MainVC.PlaceResult]()
        
        let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "text == %@", text)
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            for search in searchResults {
                if let places = Array(search.places!) as? [Place] {
                    for place in places {
                       rc.append(MainVC.PlaceResult(title: place.title, summary: place.summary, imageUrl: place.image))
                    }
                }
            }
        }
        catch {
            print("failed")
        }
        
        return rc
    }
}
