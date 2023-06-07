//
//  HomeViewModel.swift
//  ToDo
//
//  Created by Arca Sahin on 7.06.2023.
//

import Foundation
import FirebaseAuth


class Authentic {
    
   
    
    func createUser(email : String, password: String)
    
    {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print("Kayıt olunurken hata \(error?.localizedDescription)")
            }
            if authResult != nil {
                print("başarıyla kayıt olundu")
            }
        }
    }
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
            }
                }
            }
        }

