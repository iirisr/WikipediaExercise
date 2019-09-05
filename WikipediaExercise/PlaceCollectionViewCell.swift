//
//  PlaceCollectionViewCell.swift
//  WikipediaExercise
//
//  Created by Iris Ronen on 9/5/19.
//  Copyright © 2019 Iris Ronen. All rights reserved.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateImage(urlString: String?) {
        if urlString == nil {
            imageView.image = nil
        }
        else if let imageURL = URL(string: urlString!) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = NSData(contentsOf: imageURL) {
                    DispatchQueue.main.async { [weak weakSelf = self] in
                        weakSelf?.imageView.image = UIImage(data: imageData as Data)
                    }
                }
            }
        }
        
    }

}
