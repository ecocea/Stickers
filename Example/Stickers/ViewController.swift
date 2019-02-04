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
    var timer = Timer()
    var images = [UIImage]()
    
    @IBOutlet var draggableContainerView: DraggableContainerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        draggableContainerView.configureCollection(with: urls)
        draggableContainerView.delegate = self
        draggableContainerView.containerDelegate = self
    }
    
    @IBAction func addSticker(_ sender: Any) {
        draggableContainerView.displayCollection()
    }
    
    @IBAction func takeScreenshot(_ sender: Any) {
        if let gifsDescription = draggableContainerView.calculateMinimumLoopDuration() {
            self.timeInterval = gifsDescription.time
            self.numberOfFrames = gifsDescription.frame
            scheduledTimerWithTimeInterval(self.timeInterval)
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + Double(numberOfFrames) * gifsDescription.maxTime, execute: {
                let url = UIImage.animatedGif(from: self.images, timeBetweenFrames: self.timeInterval)
                UIImage.saveGif(url: url!)
                self.timer.invalidate()
            })
        } else {
            self.screenshot()
        }
    }
    
    func scheduledTimerWithTimeInterval(_ timerInterval: Double){
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.screenshot), userInfo: nil, repeats: true)
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

extension ViewController: DraggableContainerDelegate {
    func displayAlert() {
        let alert = UIAlertController(title: "Alert", message: "Not possible to add two Gifs on a picture", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
                print("Url = \(fileURL)")
                return fileURL
            }
        }
        return nil
    }
}
