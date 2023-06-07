//
//  ViewController.swift
//  ToDo
//
//  Created by Arca Sahin on 7.06.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController, UITableViewDataSource {
 
    
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    
    var messages : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List"
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        self.table.addGestureRecognizer(gesture)
        view.addSubview(table)
        table.dataSource = self
        loadMessages()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    table.frame = view.bounds
}
    
    @objc func didSwipe(gesture: UIGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.ended {
            let swipeLocation = gesture.location(in: self.table)
            if let swipedIndexPath = table.indexPathForRow(at: swipeLocation) {
                if let swipedCell = self.table.cellForRow(at: swipedIndexPath) {
                    let removedMessages = messages[swipedIndexPath.row]
                    let deletedData : [String : Any] = ["todo" : removedMessages,
                                                        "sender": Auth.auth().currentUser!.email!,
                                                        "updatedDate" : Timestamp(date: Date()),
                                                        "completionDate": Timestamp(date: Date())]
                    Firestore.firestore().collection("didData").addDocument(data: deletedData) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            let deleteAlert = UIAlertController(title: "To Do silinmiştir", message: "Did Do sayfasına başarıyla eklendi.", preferredStyle: .alert)
                            deleteAlert.addAction(UIAlertAction(title: "Tamam", style: .default))
                            self.present(deleteAlert, animated: true)
                            print("Document successfully deleted!")
                        }
                    }
                    Firestore.firestore().collection("data").whereField("todo", isEqualTo: removedMessages).addSnapshotListener { querySnapshot, err in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                document.reference.delete()
                            }
                        }
                    }
                }
            }
        }
    }

    
    @objc private func addTapped() {
        
        let alert = UIAlertController(title: "New To Do", message: "Enter the new to do", preferredStyle: .alert)
        alert.addTextField {
            field in field.placeholder = "Enter to do.."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            if let field = alert.textFields?.first {
    
                if let text = field.text, !text.isEmpty {
                    if text.count > 255 {
                        let countAlert = UIAlertController(title: "Hata", message: "255 harften fazla giremezsiniz", preferredStyle: .alert)
                        countAlert.addAction(UIAlertAction(title: "Tamam", style: .default))
                        self.present(countAlert, animated: true)
                        return
                    }
                    
                    let docData: [String : Any] = [
                        "todo": field.text!,
                        "sender": Auth.auth().currentUser!.email!,
                        "createdDate" : Timestamp(date: Date()),
                        "updatedDate" : Timestamp(date: Date())]
                    Firestore.firestore().collection("data").addDocument(data: docData) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                
            }
        }
        }))
        present(alert, animated: true)
    }
    func loadMessages() {
          
        Firestore.firestore().collection("data").whereField("sender", isEqualTo: Auth.auth().currentUser!.email!).order(by: "createdDate", descending: true).addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                  
                  self.messages = []
        
                  
                  for document in querySnapshot!.documents {
                      let data  = document.data()
                      if let messageBody = data["todo"] as? String{
                          self.messages.append(messageBody)
                          
                          
                          DispatchQueue.main.async {
                              self.table.reloadData()
                              let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                              self.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
                              
                          }
                          
                      }
                  }
              }
                  }
              
          
          
      }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel!.text = message
        return cell
    }
    
    
}

