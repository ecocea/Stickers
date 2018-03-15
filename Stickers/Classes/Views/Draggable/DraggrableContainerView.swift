//
//  DraggrableContainerView.swift
//  Stickers
//
//  Created by Alexis Suard on 12/03/2018.
//

import Foundation
import UIKit

open class DraggableContainerView: UIView {
    
    var stickerSources = [Constants.StickerSource]()
    var stickerContainer: StickersContainerView?
    var binView = UIImageView(image: UIImage(named: "binIcon", in:  Bundle(for:DraggableContainerView.self) , compatibleWith: nil))

    open var delegate: DraggableItemDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(recognizer:)))
        self.addGestureRecognizer(pinchGesture)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(recognizer:)))
        self.addGestureRecognizer(rotateGesture)
        setupBinView()
        self.delegate = self
        
    }
    
    func setupBinView() {
        binView.tintColor = .white
        
        binView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(binView)
        binView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        binView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
        binView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        binView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        binView.isHidden = true
        
    }
    
    
    func maxRect(from view: UIView) -> CGRect {
        var rect = view.frame
        for case let sticker as DraggableImageView in subviews {
            if rect.intersects(sticker.frame) {
                rect = rect.union(sticker.frame)
            }
        }
       
        return rect
        
    }
    
    //MARK: Configure collection
    public func configureCollectionWithImages(_ images: [UIImage]) {
        self.stickerSources = images.map { Constants.StickerSource.image($0) }
        stickerContainer = StickersContainerView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ))
        stickerContainer?.datasource = self
        stickerContainer?.setupCollectionData()
        self.addSubview(stickerContainer!)
    }
    
    public func configureCollectionWithUrls(_ urls: [URL]) {
        self.stickerSources = urls.map { Constants.StickerSource.url($0) }
        stickerContainer = StickersContainerView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ))
        stickerContainer?.datasource = self
        stickerContainer?.setupCollectionData()
        self.addSubview(stickerContainer!)
        
    }
    
    public func configureCollection(with stringUrls: [String]) {
        let urls = stringUrls.flatMap { URL(string: $0) }
        configureCollectionWithUrls(urls)
    }
    
    public func displayCollection() {
        guard let container = self.stickerContainer else { return }
        self.bringSubview(toFront: container)
        UIView.animate(withDuration: 0.3) {
            container.frame.origin.y = UIScreen.main.bounds.height - 300
        }
    }
    
    //MARK: Gesture
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        for view in self.subviews where view is DraggableImageView {
            let middlePoint = recognizer.location(in: view)
            if view.point(inside: middlePoint, with: nil) {
                view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
                recognizer.scale = 1
                return
            }
        }
    }
    
    @objc func handleRotation(recognizer: UIRotationGestureRecognizer) {
        for view in self.subviews where view is DraggableImageView {
            
            let middlePoint = recognizer.location(in: view)
            if view.point(inside: middlePoint, with: nil) {
                view.transform = view.transform.rotated(by: recognizer.rotation)
                if recognizer.rotation != 0 {
                    (view as! DraggableImageView).rotated = recognizer.rotation
                }
                
                recognizer.rotation = 0
                return
            }
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if let view = touch?.view, let stickerView = self.stickerContainer, !view.isIn(stickerView) {
            UIView.animate(withDuration: 0.3) {
                self.stickerContainer?.frame.origin.y = UIScreen.main.bounds.height
                self.stickerContainer?.collectionHeightConstraint.constant = Constants.Section.mid.rawValue - 70
            }
        }
        
    }
    
    //MARK: Screenshot
    public func takeScreenshotAndSaveItToLibrary(imageView: UIView) {
        let rect = maxRect(from: imageView)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        drawHierarchy(in: CGRect.init(x: 0, y: -rect.origin.y, width: bounds.width, height: bounds.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
       
    }
    
    public func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}



extension DraggableContainerView: StickersDatasource {
    var stickerImages: [Constants.StickerSource] {
        get {
            return self.stickerSources
        }
    }
    
    func add(image: UIImage) {
        let image = DraggableImageView(image: image)
        
        image.setup(with: self)
        image.delegate = self.delegate
        image.binZone = binView.frame
        UIView.animate(withDuration: 0.3) {
            self.stickerContainer?.frame.origin.y = UIScreen.main.bounds.height
        }
    }
    
}

extension DraggableContainerView: DraggableItemDelegate {
    open func isMoving() {
        binView.isHidden = false
        self.bringSubview(toFront: binView)
    }
    open func isStopping() {
        binView.isHidden = true
    }
}

