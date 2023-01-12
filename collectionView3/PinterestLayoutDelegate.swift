//
//  PinterestLayout.swift
//  collectionView3
//
//  Created by Zeynep Özdemir Açıkgöz on 12.01.2023.
//


import UIKit

/*//orijinal görüntü boyutlarını elde etmek, böylece orjinal görüntünün boyutlarını hesaplayabilmek için oluşturuyoruz.
protocol CustomLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath: IndexPath) -> CGSize
    
}*/
protocol PinterestLayoutDelegate: AnyObject{
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
}

class PinterestLayout : UICollectionViewLayout {
    
 // referans oluşlturuldu
    weak var delegate: PinterestLayoutDelegate!
    // düzeni yapılandırmak için sütün sayısı ve hücre dolgusu özellikleri
    private let  numberofColums = 2
    private let cellPadding: CGFloat = 0.5
    
    //hesaplanan öznitelikleri önbelleğe almak için bir dizidir. öğe arandığında prepare(), tüm öğelerin özniteliklerini hesaplayacak ve bunları önbelleğe ekleyecek. her düzen istendiğinde, yeniden hesaplamak yerine önbellekte tutmuş olacak
    
    
    private var cashe : [UICollectionViewLayoutAttributes] = []
    
    //koleksiyonu depolamak için bir değişkene ihtiyaç var. Contentheight ekledikçe contentWidth arttırrısın ve koleksiyon görnüm genişliğine ve içeriğine göre hesaplanacak.
    private var contentHeight: CGFloat = 0
    private var contentWidht: CGFloat{
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
    
        return collectionView.bounds.width - (insets.left + insets.right)
        }

    //kolleksiyon görünümünün içeriğinin boyutunu döndürür. boyutu hesaplamak için contentWidth ve contentHeight adımları kullanılıcak
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: contentWidht, height: contentHeight)
    }
    
    
    /*
     her öğenin çerçevesini, sütuna ve önceki öğenin aynı sütundaki konnumuna göre hesaplanacak. bunu xoffset çerçeveyi ve yoffset önceki öğenin konumunu izleyerek yapılabilir.
      yatay konumuheasplamak için önce öğenin ait olduğu sütunun başlangıç x koordinatını kullanacak ve ardından hücre dolgusu eklenecek. Dikey konum, o sütundaki önceki öğenin başlangıç konumu artı önceki öğenin yüksekliğidir. Genel öğe yüksekliği görüntü yüksekliği ile içerik dolgusunuj toplamıdır.
     Bu prepare() içerisinde yapılacak. UICollectionViewLayoutAttributes birincil hedef, düzendeki her öğe için bit örneği hesaplanmaktadır.
     
     
     
     */
    
    override func prepare() {
        //içerik boşken hesaplanıyor. çünkü içerik genişliği sabittir
        guard cashe.isEmpty, let collectionView = collectionView else {
            return
        }
        //sütun geişliği hesaplanıyor
        //xoffet sutün genişliklerine dayalı olarak her sütun için diziyi x koordinatıyla bildirerek dolduruyor. Dizi, yOffset her sutün için y konumunu izler. Bu her bir sütundaki ilk öğenin ofseti olduğundan,her değeri  y offset içinde başlatılır.
        let columnWidth = contentWidht / CGFloat(numberofColums)
        //her sütunun x objesini saklamak için
        var xOffest = [CGFloat]()
        for column in 0..<numberofColums{
            // genel sütun örnek olarak Xoffseti sutğn genişliği olacak
            xOffest.append(CGFloat(column) * columnWidth)
        }
        
        //koleksiyon görünümünün gerçek çerçevesinin ne olduğunu hesaplanack
        var column = 0
        var yOffset :  [CGFloat] = .init(repeating: 0, count: numberofColums)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0){
            
            // başlangıç sıfır
            let indexPath = IndexPath(item: item, section: 0)
            
            //orijinal görüntünün boyutunu burda alınıyopr
            let photoHeight = delegate?.collectionView(collectionView, heightForItemAtIndexPath: indexPath as NSIndexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffest[column], y: yOffset[column], width: columnWidth, height: height)
            /*
            //çerçevenin yüksekliği ve genişliği  hesplanıyor
            let cellWidth = columnWidth
            
            //fotoğraf yüksekliği fotoğraf boyutuna göre değişecek
            let cellHeight = photoSize.height*cellWidth / photoSize.width
            cellHeight = cellPadding * 2 + cellHeight
             
            

            //çerçeve tanımlamaları
            let frame = CGRect(x: xOffest[column], y: yOffset[column], width: cellWidth, height: cellHeight)
             */
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = insetFrame
            cashe.append(attributes)
            
            //contentHeight yeni hesaplanan öğenin çerçevesini hesaba katmak için genişletin. ardından, yoffset çerçeveye dayalı olarak geçerli sütun için iletley,n. son oalrak, column bir sonraki öğe sütuna yerleştirilecek şekilde ilerleyin
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberofColums - 1) ? (column + 1) : 0
        }
    }
    
    //layoutAttributesForElements geçersiz kılmak için. koleksiyon görünümü prepsre(), verilen dikdörtgende hangi öğelerin görünür olduğunu belirlemek için çağırır.
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes : [UICollectionViewLayoutAttributes] = []
        for attributes in cashe {
            if attributes.frame.intersects(rect){
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cashe[indexPath.item]
    }
    
}
