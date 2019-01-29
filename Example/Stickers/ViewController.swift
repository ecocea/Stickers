//
//  ViewController.swift
//  Stickers
//
//  Created by accor-ecocea on 03/12/2018.
//  Copyright (c) 2018 accor-ecocea. All rights reserved.
//

import UIKit
import Stickers

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIView!
    
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

    
    var hasGif: Bool = false
    
    @IBOutlet var draggableContainerView: DraggableContainerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        draggableContainerView.configureCollection(with: urls)
        //draggableContainerView.configureCollectionWithImages(imgs)
        draggableContainerView.delegate = self
    }
    
    @IBAction func addSticker(_ sender: Any) {
        draggableContainerView.displayCollection()
    }
    
    @IBAction func takeScreenshot(_ sender: Any) {
        let double = draggableContainerView.calculateMinimumLoopDuration()
//        if let double = double, double > 0.0 {
//            // Do the screenShots
//        }
        print(double)
    }

    @IBAction func changePage(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GifCreator") as! GifCreator
        self.present(vc, animated: true, completion: nil)
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

