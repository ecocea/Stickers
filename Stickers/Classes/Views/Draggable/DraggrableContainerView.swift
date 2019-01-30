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
    var stickersImages = [DraggableImageView]()
    
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
    
    
    func maxRect(from rect: CGRect) -> CGRect {
        var newRect = rect
        for case let sticker as DraggableImageView in subviews {
            let stickerRectInView = sticker.frame.intersection(self.frame)
            if newRect.intersects(stickerRectInView) {
                newRect = newRect.union(stickerRectInView)
            }
        }
        return newRect
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
    public func takeScreenshotAndSaveItToLibrary(imageView: UIImageView) {
        let rect = calculateRectOfImage(from: imageView)
        if let image = imageContext(from: rect) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
    }
    
    public func takeScreenshot(imageView: UIImageView) -> UIImage? {
        let rect = calculateRectOfImage(from: imageView)
        return imageContext(from: rect)
    }
    
    
    func imageContext(from rect: CGRect) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        drawHierarchy(in: CGRect.init(x: 0, y: -rect.origin.y, width: bounds.width, height: bounds.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }
    
    func calculateRectOfImage(from imageView: UIImageView) -> CGRect {
        if imageView.contentMode == .scaleAspectFill {
            return imageView.frame
        } else {
            let imageViewSize = imageView.frame.size
            let imgSize = imageView.image?.size
            
            guard let imageSize = imgSize, imgSize != nil else {
                return CGRect.zero
            }
            
            let scaleWidth = imageViewSize.width / imageSize.width
            let scaleHeight = imageViewSize.height / imageSize.height
            let aspect = fmin(scaleWidth, scaleHeight)
            
            var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
            // Center image
            imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
            imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
            
            // Add imageView offset
            imageRect.origin.x += imageView.frame.origin.x
            imageRect.origin.y += imageView.frame.origin.y
            //Get imageRect with stickers
            imageRect = maxRect(from: imageRect)
            return imageRect
        }
    }
    
    // max values: 50 frames and 0.1s
    public func calculateMinimumLoopDuration() -> (frame: Int, time: Double, maxTime: Double)? {
        if !self.stickersImages.isEmpty {
            var durationArray = [Double]()
            var frameToFind = 0
            var frameArray = [Int]()
            var timeInterVal = 0.0
            var maxTime = 0.0
            //Find all the Gifs and select the one with the most frames
            // timeInterval corresponds to the average of time between frames for all the gifs on the picture
            stickersImages.forEach { (image) in
                if image.gifLoopDuration != 0.0 {
                    let duration = Double(round(10*image.gifLoopDuration)/10)
                    if image.frameCount > frameToFind {
                        frameToFind = image.frameCount
                    }
                    let timeBetweenFrames = (duration / Double(image.frameCount))
                    if timeBetweenFrames > maxTime {
                        maxTime = timeBetweenFrames
                    }
                    durationArray.append( duration) // 1 digit precision for video length
                    timeInterVal += timeBetweenFrames
                    frameArray.append(image.frameCount)
                }
            }
            if !frameArray.isEmpty {
                // minFrame: number of frames min divisible by each gif frame count to constitute our new Gif image
                timeInterVal = timeInterVal / Double(frameArray.count)
                timeInterVal = (timeInterVal > 0.1) ? 0.1 : timeInterVal
                maxTime = (maxTime > 0.1) ? 0.1 : maxTime
                frameToFind = findNumberOfFrames(frameToFind, frameArray: frameArray)
                return (frameToFind, timeInterVal, maxTime)
            }
            return nil
        }
        return nil
    }
    
    // To avoid long Gif, we set a maximum to 5 frames
    func findNumberOfFrames(_ startFrame: Int, frameArray: [Int]) -> Int {
        var hasCommonFrame = false
        var frameToFind = startFrame
        while !hasCommonFrame && frameToFind <= 50 {
            hasCommonFrame = true
            for frame in frameArray {
                if frameToFind % frame != 0  {
                    hasCommonFrame = false
                    frameToFind += startFrame
                    break
                }
            }
        }
        return (frameToFind > 50) ? 50 : frameToFind
    }
    
}



extension DraggableContainerView: StickersDatasource {
    var stickerImages: [Constants.StickerSource] {
        get {
            return self.stickerSources
        }
    }
    
    func add(sticker: Sticker) {
        let image = DraggableImageView(image: sticker.image)
        image.setup(with: self)
        image.delegate = self.delegate
        image.binZone = binView.frame
        UIView.animate(withDuration: 0.3) {
            self.stickerContainer?.frame.origin.y = UIScreen.main.bounds.height
        }
        if let url = sticker.url {
            image.animate(withGIFURL: url)
        }
        stickersImages.append(image)
    }
    
}

extension DraggableContainerView: DraggableItemDelegate {
   
    open func isMoving() {
        binView.isHidden = false
        self.bringSubview(toFront: binView)
    }
    
    open func isStopping(_ image: DraggableImageView?) {
        binView.isHidden = true
        if let image = image, let index = stickersImages.index(of: image) {
            stickersImages.remove(at: index)
        }
        
    }
}

