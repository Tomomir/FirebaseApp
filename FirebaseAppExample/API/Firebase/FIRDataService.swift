//
//  FIRDataService.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class FIRDataService {
    
    var ref = Database.database().reference()
    
    // MARK: - User

    func saveNewUser(user: LocalUser) {
        Logger.log(string: "saveNewUser called", type: .all)
        self.ref.child("users").child(user.userId ?? "").setValue(["email": user.email as Any,
                                                    "nickname": user.nickname as Any,
                                                    "profileImageUrl": user.profileImageUrl ?? "",
                                                    "description": user.description ?? "",
                                                    "articles": user.articles as Any,
                                                    "userId": user.userId ?? ""])
    }
    
    func getUser(userId: String, completionBlock: @escaping (Error?, LocalUser?) -> Void) {
        Logger.log(string: "getUser called", type: .all)
        let userRef = ref.child("users/\(userId)/")
        userRef.keepSynced(true)
        DispatchQueue.global().async {
            userRef.getData { error, snapshot in
                DispatchQueue.main.async {
                    if let jsonData = snapshot?.json?.data(using: .utf8) {
                        do {
                            let user = try JSONDecoder().decode(LocalUser.self, from: jsonData)
                            completionBlock(error, user)
                        } catch {
                            completionBlock(error, nil)
                        }
                    } else {
                        completionBlock(error, nil)
                    }
                }
            }
        }
        
    }
    
    //edit user stuff
    func updateUser(user: LocalUser) {
        saveNewUser(user: user)
    }
    
    //delete user
    func deleteUser(userId: String, completionBlock: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            self.ref.child("users").child(userId).removeValue { error, _ in
                if error == nil {
                    Logger.log(string: "user delete successful", type: .all)
                }
                DispatchQueue.main.async {
                    completionBlock(error)
                }
            }
        }
    }
    
    // MARK: - Article
    
    func getNewArticleId() -> String? {
        Logger.log(string: "getNewArticleId called", type: .all)
        let newArticle = self.ref.child("articles").childByAutoId()
        
        return newArticle.key
    }
    
    func createArticle(title: String, subtitle: String, content: String, completionBlock: @escaping (Error?) -> Void) {
        Logger.log(string: "createArticle called", type: .all)
        guard let articleId = getNewArticleId(),
             let uid = firUserService.currentUser?.uid else { return }
        
        DispatchQueue.global().async {
            self.ref.child("articles/\(articleId)").setValue(["creatorId": uid,
                                                              "articleId": articleId,
                                                              "title": title,
                                                              "subtitle": subtitle,
                                                              "content": content,
                                                              "creationDate": ISO8601DateFormatter().string(from: Date()),
                                                              "creatorName": firUserService.userEmail,
                                                              "status": ArticleStatus.active.stringValue]) { error, ref in
                DispatchQueue.main.async {
                    completionBlock(error)
                }
            }
        }
    }
    
    // hould prob add paging here
    func listenForArticleUpdates(completionBlock: @escaping (Error?, Article?) -> Void) {
        Logger.log(string: "listen.. called", type: .all)
        DispatchQueue.global().async { [weak self] in
            self?.ref.child("articles").observe(.value) { snapshot in
                DispatchQueue.main.async {
                    completionBlock(nil, self?.decodeArticle(from: snapshot))
                }
            }
        }
    }
    
    func getArticles(completionBlock: @escaping (Error?, [Article]) -> Void) {
        Logger.log(string: "getArticles called", type: .all)
        DispatchQueue.global().async { [weak self] in
            self?.ref.child("articles").observe(.value) { snapshot in
                if let articles = self?.decodeArticles(from: snapshot) {
                    DispatchQueue.main.async {
                        completionBlock(nil, articles)
                    }
                } else {
                    //handle error?
                }
            }
        }
        
    }
    
    func getArticle(articleId: String, completionBlock: @escaping (Error?, Article?) -> Void) {
        Logger.log(string: "getArticle called", type: .all)
        DispatchQueue.global().async { [weak self] in
            self?.ref.child("articles/\(articleId)/").getData { error, snapshot in
                if let jsonData = snapshot?.json?.data(using: .utf8) {
                    let article = try? JSONDecoder().decode(Article.self, from: jsonData)
                    DispatchQueue.main.async {
                        completionBlock(error, article)
                    }
                } else {
                    DispatchQueue.main.async {
                        completionBlock(error, nil)
                    }
                }
            }
        }
    }
    
    func deleteArticle(article: Article, completionBlock: @escaping (Error?) -> Void) {
        Logger.log(string: "deleteArticle called", type: .all)
        DispatchQueue.global().async { [weak self] in
            self?.ref.child("articles").child(article.articleId ?? "").removeValue { error, _ in
                DispatchQueue.main.async {
                    completionBlock(error)
                }
            }
        }
    }
    
    func updateUserImageUrl(url: URL, userId: String) {
        Logger.log(string: "updateUserImageUrl called", type: .all)
        ref.child("users/\(userId)").updateChildValues(["profileImageUrl": url.absoluteString])
    }
    
    // MARK: - Image
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        Logger.log(string: "loadImage called", type: .all)
        DispatchQueue.global().async {
        let data = try? Data(contentsOf: url)
            if let imageData = data {
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                  completion(image)
                }
            }
      }
    }
    
    func loadImageFromFirebaseStorage(with path: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: path)

        DispatchQueue.global().async {
            storageRef.getData(maxSize: 1024 * 1024 * 1024) { data, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        completion(image, nil)
                    }
                }
            }
        }
    }
    
    // MARK: - Utilities
    
    private func decodeArticle(from snapshot: DataSnapshot) -> Article? {
      guard let data = snapshot.value as? [String: Any] else { return nil }
      
      do {
        let decoder = JSONDecoder()
        let article = try decoder.decode(Article.self, from: JSONSerialization.data(withJSONObject: data, options: .prettyPrinted))
        return article
      } catch {
          Logger.log(error: error)
        return nil
      }
    }
    
    private func decodeArticles(from snapshot: DataSnapshot) -> [Article] {
        guard let data = snapshot.value as? [String: Any] else { return [Article]() }
        var articles = [Article]()
        
        for (_, articleData) in data {
            do {
                let decoder = JSONDecoder()
                let article = try decoder.decode(Article.self, from: JSONSerialization.data(withJSONObject: articleData, options: .prettyPrinted))
                articles.append(article)
            } catch {
                Logger.log(error: error)
            }
        }
        
        return articles
    }
}
