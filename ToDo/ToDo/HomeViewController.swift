//
//  HomeViewController.swift
//  ToDo
//
//  Created by Arca Sahin on 7.06.2023.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    let auth = Authentic()
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if passwordText.text != nil, emailText.text != nil
        {  auth.createUser(email: emailText.text!, password: passwordText.text!)
            passwordText.text = ""
        }
    }
    @IBAction func loginTapped(_ sender: Any) {
        if let email = emailText.text,let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                    self.passwordText.text = "" 
                }
            }
        }

        
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
