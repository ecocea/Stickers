//
//  ViewController.swift
//  Stickers
//
//  Created by accor-ecocea on 03/12/2018.
//  Copyright (c) 2018 accor-ecocea. All rights reserved.
//

import UIKit
import Stickers
import ImageIO
import MobileCoreServices
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIView!
    
    @IBOutlet weak var realImageVew: UIImageView!
    let urls = [
        "https://orig00.deviantart.net/6c7c/f/2009/081/2/5/louis_vuitton_finder_for_mac_by_somonette.png",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_8Ov6QCk8dcQTl3IU0bi3jfiqgbi_mWEQ7q8uFd8bdlF3KOWJ",
        "https://lh3.googleusercontent.com/proxy/TxwIo10F4BI9oDtrxxYPFmSlGi0gjhZsb7olpLi8bMWcMly0z94vYoP2W3OsowCv67axxomh_mwMWM4lr6ljrTRkmCrdjg=s530-p-k",
        "https://orig00.deviantart.net/1cc7/f/2009/081/4/9/louis_vuitton_wlm_icon_for_mac_by_somonette.png",
        "https://static.lexpress.fr/medias_11530/w_640,c_fill,g_north/louis-vuitton-32_5903794.jpg",
        "https://orig00.deviantart.net/6c7c/f/2009/081/2/5/louis_vuitton_finder_for_mac_by_somonette.png",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_8Ov6QCk8dcQTl3IU0bi3jfiqgbi_mWEQ7q8uFd8bdlF3KOWJ",
        "https://lh3.googleusercontent.com/proxy/TxwIo10F4BI9oDtrxxYPFmSlGi0gjhZsb7olpLi8bMWcMly0z94vYoP2W3OsowCv67axxomh_mwMWM4lr6ljrTRkmCrdjg=s530-p-k",
        "https://orig00.deviantart.net/1cc7/f/2009/081/4/9/louis_vuitton_wlm_icon_for_mac_by_somonette.png",
        "https://static.lexpress.fr/medias_11530/w_640,c_fill,g_north/louis-vuitton-32_5903794.jpg",
        "https://orig00.deviantart.net/6c7c/f/2009/081/2/5/louis_vuitton_finder_for_mac_by_somonette.png",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_8Ov6QCk8dcQTl3IU0bi3jfiqgbi_mWEQ7q8uFd8bdlF3KOWJ",
        "https://lh3.googleusercontent.com/proxy/TxwIo10F4BI9oDtrxxYPFmSlGi0gjhZsb7olpLi8bMWcMly0z94vYoP2W3OsowCv67axxomh_mwMWM4lr6ljrTRkmCrdjg=s530-p-k",
        "https://orig00.deviantart.net/1cc7/f/2009/081/4/9/louis_vuitton_wlm_icon_for_mac_by_somonette.png",
        "https://static.lexpress.fr/medias_11530/w_640,c_fill,g_north/louis-vuitton-32_5903794.jpg",
        "https://orig00.deviantart.net/6c7c/f/2009/081/2/5/louis_vuitton_finder_for_mac_by_somonette.png",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_8Ov6QCk8dcQTl3IU0bi3jfiqgbi_mWEQ7q8uFd8bdlF3KOWJ",
        "https://lh3.googleusercontent.com/proxy/TxwIo10F4BI9oDtrxxYPFmSlGi0gjhZsb7olpLi8bMWcMly0z94vYoP2W3OsowCv67axxomh_mwMWM4lr6ljrTRkmCrdjg=s530-p-k",
        "https://orig00.deviantart.net/1cc7/f/2009/081/4/9/louis_vuitton_wlm_icon_for_mac_by_somonette.png",
        "https://colinbendell.cloudinary.com/image/upload/c_crop,f_auto,g_auto,h_350,w_400/v1512090971/Wizard-Clap-by-Markus-Magnusson.gif",
        "https://www.kizoa.fr/img/e8nZC.gif",
        "https://www.rubriketdebrok.com/wp-content/uploads/2014/10/1410967177-dragonballzgif-0.gif"
        ]

    
    var timeInterval: Double = 0.0
    var numberOfFrames = 0
    var images = [UIImage]()
    var importedImages = [UIImage]()
    var realUrls = [URL]()
    
    @IBOutlet var draggableContainerView: DraggableContainerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        urls.forEach { (url) in
            let realUrl = URL(string: url)
            let data = try? Data(contentsOf: realUrl!)
            let image = UIImage(data: data!)
            importedImages.append(image!)
            realUrls.append(realUrl!)
            
        }
        draggableContainerView.configureCollectionWithImages(importedImages, urls: realUrls)
        draggableContainerView.delegate = self
    }
    
    @IBAction func addSticker(_ sender: Any) {
        draggableContainerView.displayCollection()
    }
    
    @IBAction func takeScreenshot(_ sender: Any) {
        self.images = self.trickyGif()
        DispatchQueue.global(qos: .background).async {
            if let gifsDescription = self.draggableContainerView.calculateMinimumLoopDuration() {
                self.timeInterval = gifsDescription
                let url = UIImage.animatedGif(from: self.images, timeBetweenFrames: self.timeInterval)
                UIImage.saveGif(url: url!)
            } else {
                self.screenshot()
            }
        }
    }
    
    //Create a Gif from a static background image and a Gif over it
    func trickyGif() -> [UIImage] {
        var gifAarray = [UIImage]()
        var frame = CGRect()
        var transform = CGAffineTransform()
        var framesArray = [UIImage?]()
        draggableContainerView.subviews.forEach({ (subview) in
            if let gifView = subview as? DraggableImageView, gifView.isAnimatingGIF {
                frame = gifView.frame
                transform = gifView.transform
                gifView.animator?.frameStore?.animatedFrames.forEach({ (frame) in
                    framesArray.append(frame.image)
                })
                gifView.removeFromSuperview()
                framesArray.forEach { (image) in
                    let imageView = UIImageView()
                    draggableContainerView.addSubview(imageView)
                    imageView.frame = frame
                    imageView.transform = transform
                    imageView.image = image
                    let gifImage = self.view.asImage()
                    gifAarray.append(gifImage)
                    imageView.removeFromSuperview()
                }
                draggableContainerView.addSubview(gifView)
            }
        })
        return gifAarray
    }
    
    @objc public func screenshot() {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.images.append(image!)
    }
}

extension ViewController: DraggableItemDelegate {
    func isStopping(_ image: DraggableImageView?) {
        draggableContainerView.isStopping(image)
    }
    
    func isMoving() {
        draggableContainerView.isMoving()
    }
}

extension UIImage {
    
    static func saveGif(url: URL) {
        PHPhotoLibrary.shared().performChanges({
            let changeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
            changeRequest?.creationDate = Date()
        }, completionHandler: { (success, error) in
            if let error = error {
                print(error)
            }
            print(success)
            
        })
    }
    
    static func animatedGif(from images: [UIImage], numberOfLoop: Int = 0, timeBetweenFrames: Double) -> URL? {
        let fileProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0, kCGImagePropertyGIFHasGlobalColorMap as String: false]]  as CFDictionary
        let frameProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFDelayTime as String): timeBetweenFrames]] as CFDictionary
        
        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL: URL? = documentsDirectoryURL?.appendingPathComponent("animated.gif")
        
        if let url = fileURL as CFURL? {
            if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) {
                CGImageDestinationSetProperties(destination, fileProperties)
                for image in images {
                    if let cgImage = image.cgImage {
                        CGImageDestinationAddImage(destination, cgImage, frameProperties)
                    }
                }
                if !CGImageDestinationFinalize(destination) {
                    print("Failed to finalize the image destination")
                }
                return fileURL
            }
        }
        return nil
    }
}

extension UIView {
    
    func asImage(rect: CGRect? = nil) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect ?? bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
