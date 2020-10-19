//
//  SliderVC.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-10-18.
//

import UIKit

class SliderVC: UIViewController {

    var cellList = [ThumbnailCollectionViewCell]()
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cellList)
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
