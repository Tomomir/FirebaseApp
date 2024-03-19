//
//  FIRUserService.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class FIRUserService: NSObject {
    
    let profilePictureStorageName = "profile_pictures"
    let profilePictureDefaultSize = CGSize(width: 200, height: 200)
    
    var currentUser: User? {
        Auth.auth().currentUser
    }

    var isUserLoggedIn: Bool {
        currentUser != nil
    }

    var userEmail: String {
        currentUser?.email ?? ""
    }
    
    // MARK: - Signup
    
    func createUser(email: String, password: String, nickname: String? = nil, completionBlock: @escaping (_ error: Error?) -> Void) {
        Logger.log(string: "create user called", type: .all)
        
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            Logger.log(string: "create user finished", type: .all)
            if let user = authResult?.user {
                let newUser = LocalUser(userId: user.uid, email: email, nickname: nickname ?? "", profileImageUrl: nil, description: nil, articles: [String]())
                firDataService.saveNewUser(user: newUser)
                completionBlock(error)
            } else {
                Logger.log(error: error)
                completionBlock(error)
            }
        }
    }
    
    // MARK: - Account management
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ error: Error?) -> Void) {
        Logger.log(string: "sign in user called", type: .all)
        
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            Logger.log(string: "sing in user finished", type: .all)
            if let error = error, let _ = AuthErrorCode.Code(rawValue: error._code) {
                Logger.log(error: error)
                completionBlock(error)
            } else {
                completionBlock(error)
            }
        }
    }
    
    func logoutUser() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            Logger.log(error: signOutError)
        }
    }
    
    func deleteLoggedUser(completionBlock: @escaping (_ error: Error?) -> Void) {
        Logger.log(string: "about to delete logged user", type: .all)
        
        guard let userIdToDelete = Auth.auth().currentUser?.uid else {
            let error: Error = NSError(domain: "User not logged in", code: 800, userInfo: nil)
            Logger.log(error: error)
            completionBlock(error)
            return
        }

        firDataService.getUser(userId: userIdToDelete) { [weak self] error, localUser in
            if error == nil {
                self?.deleteAccount { error in
                    if localUser?.profileImageUrl != "" {
                        self?.deleteProfileImage(userIdToDelete) { error in
                            if error != nil {
                                completionBlock(error)
                                return
                            } else {
                                completionBlock(error)
                            }
                        }
                    } else {
                        completionBlock(error)
                    }
                }
            } else {
                let error: Error = NSError(domain: "User not logged in", code: 800, userInfo: nil)
                Logger.log(error: error)
                completionBlock(error)
                return
            }
        }

    }
    
    private func deleteAccount(completionBlock: @escaping (_ error: Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            let error: Error = NSError(domain: "User not logged in", code: 800, userInfo: nil)
            Logger.log(error: error)
            completionBlock(error)
            return
        }
        
        let uid = user.uid

        Logger.log(string: "about to delete account: \(user.email ?? "")", type: .all)
        user.delete { error in
            if let error = error {
                Logger.log(error: error)
                completionBlock(error)
            } else {
                firDataService.deleteUser(userId: uid) { error in
                    completionBlock(error)
                }
            }
        }
    }
    
    func resetPasswordForEmail(email: String, completionBlock: @escaping (_ error: Error?) -> Void) {
        Logger.log(string: "about to reset password for email: \(email)", type: .all)
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                Logger.log(error: error)
                completionBlock(error)
            } else {
                Logger.log(string: "reset email sent succcessfully", type: .all)
                completionBlock(nil)
            }
        }
    }
    
    // MARK: - Profile picture
    
    func updateProfileImage(_ image: UIImage? = nil, _ completionBlock: ((Error?, URL?) -> ())? = nil){
        Logger.log(string: "about to upload profile image", type: .all)
        
        guard let resizedImage = image?.resizeImage(targetSize: self.profilePictureDefaultSize) else {
            let error = NSError(domain: "could not resize image (wrong image, or is nil)", code: 800, userInfo: nil)
            Logger.log(error: error)
            completionBlock?(error, nil)
            return
        }
        
        guard let imageData = resizedImage.pngData() else {
            let error = NSError(domain: "could not convert UIImage to Data", code: 800, userInfo: nil)
            Logger.log(error: error)
            completionBlock?(error, nil)
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            let error: Error = NSError(domain: "no user signed in", code: 800, userInfo: nil)
            Logger.log(error: error)
            completionBlock?(error, nil)
            return
        }

        let profileImgReference = Storage.storage().reference().child(profilePictureStorageName).child("\(user.uid).png")

        _ = profileImgReference.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                Logger.log(error: error)
                completionBlock?(error, nil)
            } else {
                profileImgReference.downloadURL(completion: { (url, error) in
                    if let url = url {
                        Logger.log(string: "image upload successfull, url: \(url.absoluteString)", type: .all)
                        
                        if let userId = self.currentUser?.uid {
                            firDataService.updateUserImageUrl(url: url, userId: userId)
                        }

                        completionBlock?(error, url)
                    } else {
                        Logger.log(error: error)
                        completionBlock?(error, nil)
                    }
                })
            }
        }
    }
    
    func deleteProfileImage(_ userId: String, completionBlock: @escaping ((Error?) -> ())) {
        Logger.log(string: "about to delete profile image", type: .all)
        
        let profileImgReference = Storage.storage().reference().child(profilePictureStorageName).child("\(userId).png")
        
        profileImgReference.delete { error in
            if let error = error {
                Logger.log(error: error)
                completionBlock(error)
            } else {
                Logger.log(string: "delete profile picture successful", type: .all)
                completionBlock(nil)
            }
        }
    }
    
    func deleteProfileImageForCurrentUser(_ completionBlock: @escaping ((Error?) -> ())) {
        Logger.log(string: "about to delete profile image", type: .all)
        
        guard let user = Auth.auth().currentUser else {
            let error: Error = NSError(domain: "no user signed in", code: 800, userInfo: nil)
            Logger.log(error: error)
            completionBlock(error)
            return
        }
        
        let profileImgReference = Storage.storage().reference().child(profilePictureStorageName).child("\(user.uid).png")
        
        profileImgReference.delete { error in
            if let error = error {
                Logger.log(error: error)
                completionBlock(error)
            } else {
                Logger.log(string: "delete profile picture successful", type: .all)
                completionBlock(nil)
            }
        }
    }
}

