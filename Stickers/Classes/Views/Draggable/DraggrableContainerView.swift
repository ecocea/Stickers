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
        
    }
    
    func setupBinView() {
        
        binView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(binView)
        binView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        binView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
        binView.widthAnchor.constraint(equalToConstant: 50)
        binView.heightAnchor.constraint(equalToConstant: 50)
        binView.isHidden = true
        
    }
    
    //MARK: Configure collection
    public func configureCollection(with images: [UIImage]) {
        self.stickerSources = images.map { Constants.StickerSource.image($0) }
        stickerContainer = StickersContainerView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ))
        stickerContainer?.datasource = self
        stickerContainer?.setupCollectionData()
        self.addSubview(stickerContainer!)
    }
    
    public func configureCollection(with urls: [URL]) {
        self.stickerSources = urls.map { Constants.StickerSource.url($0) }
        stickerContainer = StickersContainerView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ))
        stickerContainer?.datasource = self
        stickerContainer?.setupCollectionData()
        self.addSubview(stickerContainer!)
        
    }
    
    public func configureCollection(stringUrls: [String]) {
        let urls = stringUrls.flatMap { URL(string: $0) }
        configureCollection(with: urls)
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
            UIView.animate(withDuration: 0.3) { self.stickerContainer?.frame.origin.y = UIScreen.main.bounds.height }
        }
        
    }
    
    //MARK: Screenshot
    public func takeScreenshotAndSaveItToLibrary() {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
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
        image.delegate = self
        image.binZone = binView.frame
        UIView.animate(withDuration: 0.3) {
            self.stickerContainer?.frame.origin.y = UIScreen.main.bounds.height
        }
    }
    
}

extension DraggableContainerView: DraggableItemDelegate {
    func isMoving() {
        binView.isHidden = false
        self.bringSubview(toFront: binView)
    }
    func isStopping() {
        binView.isHidden = true
    }
}

