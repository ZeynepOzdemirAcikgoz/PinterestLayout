//
//  ImageViewerViewController.swift
//  collectionView3
//
//  Created by Zeynep Özdemir Açıkgöz on 12.01.2023.
//

import UIKit

class ImageViewerViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpImageView()
        
    }
    private func setUpImageView(){
        guard let name = imageName else { return }
        
        if let image = UIImage(named: name){
            imageView.image = image
        }
    }
    
}
