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
        if self.imageView.isAnimatingGIF {
            self.imageView.stopAnimating()
        }
        self.imageView.image = nil
        self.imageView.prepareForReuse()
    }
    
    func fillCell(sticker: Sticker, shouldAnimate: Bool) {
        if let isGif = sticker.isGif, isGif, let url = sticker.url, shouldAnimate {
            self.imageView.animate(withGIFURL: url)
        } else {
            self.imageView.image = sticker.image
        }
    }
}
