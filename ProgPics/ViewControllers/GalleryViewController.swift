//
//  GalleryViewController.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-09-28.
//

import UIKit
import Firebase

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var progID:String?
    var numberOfPictures = 0
    var progRef:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progRef = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Progressions").child(progID!)
        print(progID)
        // Do any additional setup after loading the view.
    }
    
    //func numberOfSections(in collectionView: UICollectionView) -> Int {
        
    //}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        progRef?.child("Images").observe(.value, with: { snapshot in
            let count = snapshot.childrenCount
            self.numberOfPictures = Int(count)
            print(self.numberOfPictures)
        })
        print(numberOfPictures)
        return numberOfPictures
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnail cell" , for: indexPath) as! ThumbnailCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Int(collectionView.frame.width/3) - 5, height: Int(collectionView.frame.width/3) - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        //LADDA RÄTT BILD o GÖR IMAGEVY SOM TÄCKER SKÄRMEN SYNLIG

    }
    
    /*func imageTapped(_ sender: nil) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    */
    /*@objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
   */
    
}
