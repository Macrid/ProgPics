//
//  RegisterViewController.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-09-29.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextbox: UITextField!
    @IBOutlet weak var passwordTextbox: UITextField!
    @IBOutlet weak var passwordConfirmTextbox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
      }

    @IBAction func register(_ sender: Any) {
        if(passwordTextbox.text == passwordConfirmTextbox.text)
        {
            Auth.auth().createUser(withEmail: emailTextbox.text!, password: passwordTextbox.text!)
            { authResult, error in
                if(error == nil)
                {
                
                    self.dismiss(animated: false, completion: nil)
                }
                else
                {
                    print("error med skapning")
                    print(error?.localizedDescription)
                }
            }
        }
        else
        {
            //popup passwords not matching
        }
    }

}
