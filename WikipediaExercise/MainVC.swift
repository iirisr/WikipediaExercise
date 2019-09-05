//
//  MainVC.swift
//  WikipediaExercise
//
//  Created by Iris Ronen on 9/5/19.
//  Copyright © 2019 Iris Ronen. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate, SearchProtocol {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var wikipediaButton: UIButton!
    @IBOutlet weak var localButton: UIButton!
    @IBOutlet weak var innerLocalView: UIView!
    @IBOutlet weak var innerWikipediaView: UIView!
    @IBOutlet weak var placesCollection: UICollectionView!
    
    
    struct PlaceResult {
        var title = String()
        var summary = String()
        var imageUrl: String?
    }
    
    var isWikipediaSearchPressed = true
    var errorMessage: String?
    
    var wikipediaSearch = WikipediaSearch()
    var localSearch = LocalSearch()
    
    var places: [PlaceResult] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesCollection.delegate = self
        placesCollection.dataSource = self
        searchTextField.delegate = self
        
        wikipediaSearch.delegate = self
        localSearch.delegate = self
        
        sourceButtonPressed(wikipediaButton)
        
        placesCollection.register(UINib(nibName: "PlaceHeaderResusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.placesHeader)
        let layout = placesCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: placesCollection.frame.width, height: 30)
        
        placesCollection.register(UINib(nibName: "PlaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifiers.placeCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wikipediaButton.cornerRadius = wikipediaButton.frame.width / 2
        localButton.cornerRadius = localButton.frame.width / 2
        innerWikipediaView.cornerRadius = innerWikipediaView.frame.width / 2
        innerLocalView.cornerRadius = innerLocalView.frame.width / 2
    }
    
    @IBAction func sourceButtonPressed(_ sender: UIButton) {
        isWikipediaSearchPressed = sender == wikipediaButton
        
        innerWikipediaView.isHidden = !isWikipediaSearchPressed
        innerLocalView.isHidden = isWikipediaSearchPressed
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        places = []
        placesCollection.reloadData()
        if let text = searchTextField.text {
            if isWikipediaSearchPressed {
                wikipediaSearch.search(forText: text)
            } else {
                localSearch.search(forText: text)
            }
        }
    }
    
    internal func updateSearchResults(_ data: Data) {
        print("updateSearchResults")
        
        var response: [String: Any]?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let parseError as NSError {
            errorMessage = "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let geonames = response!["geonames"] as? [[String: Any]] else {
            errorMessage = "Error parsing\n"
            return
        }
        
        for place in geonames {
            guard let title = place["title"] as? String else {
                errorMessage = "Error parsing the title\n"
                return
            }
            guard let summary = place["summary"] as? String else {
                errorMessage = "Error parsing the summary\n"
                return
            }
            let imageUrl = place["thumbnailImg"] as? String
            
            print("title=\(title), summary=\(summary)" )
            places.append(PlaceResult(title: title, summary: summary, imageUrl: imageUrl))
        }
        
        
        self.saveToCoreData()
        
        print("Done parsing")
        DispatchQueue.main.async {
            self.placesCollection.reloadData()
        }
    }
    
    internal func updateSearchResults(_ results: [MainVC.PlaceResult]) {
        print("updateSearchResults")
        places = results
        DispatchQueue.main.async {
            self.placesCollection.reloadData()
        }
    }

    private func saveToCoreData() {
        DispatchQueue.main.async {
            if let text = self.searchTextField.text {
                CoreDataModelForSearch().saveToCoreData(text: text, searchResults: self.places)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection")
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.placeCell, for: indexPath) as! PlaceCollectionViewCell
        cell.titleLabel.text = places[indexPath.row].title
        cell.summaryLabel.text = places[indexPath.row].summary
        cell.updateImage(urlString: places[indexPath.row].imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifiers.placesHeader, for: indexPath as IndexPath) as! PlaceHeaderResusableView
            
            headerView.headerLabel.text = searchTextField.text
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.height * 0.2
        let width = searchTextField.frame.width
        return CGSize(width: width, height: height)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
