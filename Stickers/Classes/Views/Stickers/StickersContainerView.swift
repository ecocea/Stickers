//
//  StickersContainerView.swift
//  Stickers
//
//  Created by Alexis Suard on 12/03/2018.
//

import Foundation
import UIKit
import Kingfisher
import NVActivityIndicatorView

protocol StickersDatasource {
    var stickerImages: [Constants.StickerSource] { get }
    func add(image: UIImage) -> Void
}

class StickersContainerView: UIView{
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loader: NVActivityIndicatorView!
    
    let screenHeight = UIScreen.main.bounds.height
    var datasource: StickersDatasource?
    var images = [UIImage]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let bundle = Bundle(for: StickersContainerView.self)
        bundle.loadNibNamed("StickersContainerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        //Collection
        self.collectionView.register(UINib(nibName: "StickersCollectionCell", bundle: bundle), forCellWithReuseIdentifier: "stickersCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupGesture()
    }
    
    func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.addGestureRecognizer(panGesture)
        
    }
    
    func setupCollectionData() {
        guard let datasource = datasource else { return }
        loader.startAnimating()
        let dispatchGroup = DispatchGroup()
        datasource.stickerImages.forEach { (value) in
            
            dispatchGroup.enter()
            switch value {
            case .image(let image):
                self.images.append(image)
                dispatchGroup.leave()
            case .url(let url):
                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { (image, error, _, _) in
                    if let img = image {
                        self.images.append(img)
                    }
                    dispatchGroup.leave()
                    
                }
            }
        }
        dispatchGroup.notify(queue: .main, execute: {
            self.collectionView.reloadData()
            self.loader.stopAnimating()
        })
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let velocity = recognizer.velocity(in: self)
        let y = self.frame.minY
        switch recognizer.state {
        case .changed:
            if y + translation.y <= screenHeight - Constants.Section.low.rawValue && y + translation.y >= screenHeight - Constants.Section.high.rawValue {
                self.frame = CGRect(x: 0, y: y + translation.y, width: self.frame.width, height: self.frame.height)
                recognizer.setTranslation(CGPoint.zero, in: self)
            }
        case .ended:
            let section = Constants.Section.chooseSection(fromVelocity: velocity.y, andHeight: y + translation.y)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.frame.origin.y = self.screenHeight - section.rawValue
                if section == .low {
                    self.collectionHeightConstraint.constant = Constants.Section.mid.rawValue - 70
                } else {
                    self.collectionHeightConstraint.constant = section.rawValue - 70
                }
                
            })
            
        default:
            break
        }
    }
    
}

extension StickersContainerView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickersCell", for: indexPath as IndexPath) as! StickersCollectionCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = images[indexPath.item]
        datasource?.add(image: item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let point = collectionView.convert(cell.frame.origin, to: collectionView.superview)
            if point.y < 0 {
                cell.alpha = 0
            }
            else if point.y < (cell.frame.height-30) {
                cell.alpha = point.y/(cell.frame.height-30)
            } else {
                cell.alpha = 1
            }
            
        }
    }
    
}
