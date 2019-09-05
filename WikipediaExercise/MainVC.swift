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
    
    struct Place {
        var title = String()
        var summary = String()
        var imageView = UIImageView()
    }
    
    var isWikipediaSearchPressed = true
    
    var places: [Place] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        sourceButtonPressed(wikipediaButton)
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
    
    private func searchWiki(forText text: String) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.placeCell, for: indexPath) as! PlaceCollectionViewCell
        //cell.tag = indexPath.row
        //let cell.imageView =
        return cell
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
