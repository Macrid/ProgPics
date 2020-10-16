//
//  NewProgressionViewController.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-09-24.
//

import UIKit
import Firebase

class NewProgressionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var firstImage: UIImageView!
    var ref = Database.database().reference()
    var progRef = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Progressions").childByAutoId()
    var imagePicked:Bool = false
    let progID = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(progRef)
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
            imagePicked = true
        }
        else{
            print("ERORR MED VALD BILD")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if (titleTextBox.text == "") {
            return
        }

        let prog : [String : Any] = ["Progression Title" : titleTextBox.text!, "Date Started" : getTodaysDate()]
        
        //self.ref.child(Auth.auth().currentUser!.uid).child("Progressions").child(progID).setValue(prog)
        progRef.setValue(prog)
        
        if (imagePicked == true)
        {
            uploadImage(imageView: firstImage)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(imageView: UIImageView)
    {
        let jpegImage = imageView.image?.jpegData(compressionQuality: 1.0)
        
        let imageID = UUID().uuidString
        //self.ref.child(Auth.auth().currentUser!.uid).child("Progressions").child(progID).child("Images").child(imageID).child("Date").setValue(getTodaysDate())
        self.progRef.child("Images").child(imageID).child("Date").setValue(getTodaysDate())
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(Auth.auth().currentUser!.uid).child(imageID)
        
        let uploadTask = imageRef.putData(jpegImage!, metadata: nil) {(metadata, error) in
            guard let metadata = metadata else {
                print("Error with upload")
                return
            }
            
        }
    }
    
    func getTodaysDate() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = Date()
        let todaysDate = formatter.string(from: date)
        return todaysDate
    }
}
