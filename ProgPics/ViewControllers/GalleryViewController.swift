//
//  GalleryViewController.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-09-28.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var testString = "fail"
    var numberOfPictures:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(testString)
        numberOfPictures = 15
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnail cell" , for: indexPath) as! ThumbnailCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Int(collectionView.frame.width/3) - 5, height: Int(collectionView.frame.width/3) - 5)
    }
    
}
