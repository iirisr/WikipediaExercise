//
//  MainVC.swift
//  WikipediaExercise
//
//  Created by Iris Ronen on 9/5/19.
//  Copyright © 2019 Iris Ronen. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var wikipediaButton: UIButton!
    @IBOutlet weak var localButton: UIButton!
    @IBOutlet weak var innerLocalView: UIView!
    @IBOutlet weak var innerWikipediaView: UIView!
    @IBOutlet weak var placesCollection: UICollectionView!
    
    
    struct Place {
        var title = String()
        var summary = String()
        var imageUrl: String?
    }
    
    var isWikipediaSearchPressed = true
    var errorMessage: String?
    
    var places: [Place] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesCollection.delegate = self
        placesCollection.dataSource = self
        searchTextField.delegate = self
        
        sourceButtonPressed(wikipediaButton)
        
        placesCollection.register(UINib(nibName: "PlaceHeaderResusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.placesHeader)
        let layout = placesCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: placesCollection.frame.width, height: 30)
        
        placesCollection.register(UINib(nibName: "PlaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifiers.placeCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if let text = searchTextField.text {
            searchWiki(forText: text)
        }
    }
    
    private func searchWiki(forText text: String) {
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
                self?.updateSearchResults(data)
            }
        })
        
        dataTask?.resume()
    }
    
    private func updateSearchResults(_ data: Data) {
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
            places.append(Place(title: title, summary: summary, imageUrl: imageUrl))
        }
        
        print("Done parsing")
        DispatchQueue.main.async {
            self.placesCollection.reloadData()
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
        if let text = textField.text {
            searchWiki(forText: text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    



}
