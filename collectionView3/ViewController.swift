//
//  ViewController.swift
//  collectionView3
//
//  Created by Zeynep Özdemir Açıkgöz on 12.01.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var items:  [Item] = [Item(imageName: "1"),
                          Item(imageName: "2"),
                          Item(imageName: "3"),
                          Item(imageName: "4"),
                          Item(imageName: "5"),
                          Item(imageName: "6"),
                          Item(imageName: "7"),
                          
                          Item(imageName: "9")]
    
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    let cellIdentifier = "ItemCollectionViewCell"
    let viewImageSegue = "toImageViewerController"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpColletionViewItemSize()
    }
    // detya görünüm
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let item = sender as! Item
        
        if segue.identifier == viewImageSegue {
            if let vc = segue.destination as? ImageViewerViewController{
                vc.imageName = item.imageName
            }
        }
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    //utun ölçüleri belirlendi
    private func setUpColletionViewItemSize(){
//        if collectionViewFlowLayout == nil {
//            let numberofItemPerRow: CGFloat = 2
//            let lineSpacing: CGFloat = 5
//            let internItemSpacing: Float = 2
//
//            let width = (collectionView.frame.width - (numberofItemPerRow - 1) * CGFloat(internItemSpacing) ) / numberofItemPerRow
//            let height = width
//            collectionViewFlowLayout = UICollectionViewFlowLayout()
//            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
//
//            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
//            collectionViewFlowLayout.scrollDirection = .vertical
//            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
//            collectionViewFlowLayout.minimumInteritemSpacing = CGFloat(internItemSpacing)
//
//            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
//        }
        
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        collectionView.collectionViewLayout = pinterestLayout
    }


}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ItemCollectionViewCell
        cell.imageView?.image = UIImage(named: items[indexPath.item].imageName)
       
        cell.layer.cornerRadius = 15
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        let item = items[indexPath.item]
        performSegue(withIdentifier: viewImageSegue, sender: item)
        
    }
}
extension ViewController: PinterestLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let image = UIImage(named: items[indexPath.item].imageName)
        if let height = image?.size.height{
            return height 
        }
        return 0.0
    }
    }
    
   
   
