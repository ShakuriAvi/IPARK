//
//  FirebaseAuthManager.swift
//  Final Project
//
//  Created by מוטי שקורי on 28/05/2021.
//

import FirebaseAuth
import UIKit
class FirebaseAuthManager {
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
}
