//
//  NewProgressionViewController.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-09-24.
//

import UIKit
import Firebase

class NewProgressionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var firstImage: UIImageView!
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPicture(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = true
        
        self.present(image, animated: true)
        {
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            firstImage.image = image
        }
        else{
            print("ERORR MED VALD BILD")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = Date()
        let todaysDate = formatter.string(from: date)

        let prog : [String : Any] = ["Progression Title" : titleTextBox.text, "Date Started" : todaysDate]
        
        self.ref.child(Auth.auth().currentUser!.uid).child("Progressions").childByAutoId().setValue(prog)
        self.dismiss(animated: true, completion: nil)
    }
}
