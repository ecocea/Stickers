//
//  StickersCollectionCell.swift
//  Stickers
//
//  Created by Alexis Suard on 12/03/2018.
//

import Foundation
import UIKit

class StickersCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: GIFImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.alpha = 1
        self.imageView.prepareForReuse()
    }
    
    func fillCell(url: URL?, image: UIImage?) {
        if let url = url {
            imageView.animate(withGIFURL: url)
        } else if let image = image {
            imageView.image = image
        }
    }
}
