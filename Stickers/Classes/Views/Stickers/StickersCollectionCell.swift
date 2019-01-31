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
    
    func fillCell(sticker: Sticker) {
        if let isGif = sticker.isGif, isGif, let url = sticker.url {
            self.imageView.animate(withGIFURL: url)
        } else {
            self.imageView.image = sticker.image
        }
    }
}
