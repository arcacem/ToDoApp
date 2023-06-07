//
//  DidDoViewController.swift
//  ToDo
//
//  Created by Arca Sahin on 7.06.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DidDoViewController: UIViewController, UITableViewDataSource {
   
    
    var messages : [String] = []
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Did Do List"
        view.addSubview(table)
        table.dataSource = self
        loadMessages()

           }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func loadMessages() {
          
        Firestore.firestore().collection("didData").whereField("sender", isEqualTo: Auth.auth().currentUser!.email!).order(by: "updatedDate", descending: true).addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, err) in
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
