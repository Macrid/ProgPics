//
//  ViewController.swift
//  ProgPics
//
//  Created by Admin on 2020-09-15.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
      }
    
    @IBAction func doLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: PasswordTextField.text!)
        { authResult, error in
            if(error == nil)
            {
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                print(error?.localizedDescription)
            }
            
        }
    }
}

