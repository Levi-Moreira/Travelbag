//
//  ChatListTableViewController.swift
//  Travelbag
//
//  Created by ifce on 13/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Nuke
import ARSLineProgress

class ChatListTableViewController: UITableViewController {

    var chats = [ChatEntry]()
    let userID = Auth.auth().currentUser?.uid
    
    override func viewWillAppear(_ animated: Bool) {
        ARSLineProgress.show()
        getChats()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chats.count
    }

    func getChats() {
       
        chats.removeAll()
        ref.child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! [String: Any]
            
            for child in value {
                
                let childValue = child.value as? [String: Any]
                
                if let json = childValue {
                    self.chats.append(ChatEntry.init(with: json))
                }
            }
            
            self.chats = self.chats.filter({ (chats) -> Bool in
                chats.firstUserUID == self.userID || chats.secondUserUID == self.userID
            })
            
            self.chats.sort{ return $0.0.lastMessageDate ?? 0 > $0.1.lastMessageDate ?? 0}
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                ARSLineProgress.hide()
            }
            
        }) { (error) in
            print(error)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as! ChatListTableViewCell
        
            if chats[indexPath.row].firstUserUID == self.userID {
            
            cell.nameUser.text = chats[indexPath.row].secondUserName ?? ""
            cell.lastMessageUser.text = chats[indexPath.row].lastMessage ?? ""
            cell.lastMessageDateUser.text = chats[indexPath.row].timeToNow ?? "nil"
            
            if let url = chats[indexPath.row].secondUserImage {
                if url.isValidHttpsUrl {
                    Nuke.loadImage(with: URL(string: url)!, into: cell.imageUser)
                }
            }
            
        } else {
        
            cell.nameUser.text = chats[indexPath.row].firstUserName ?? ""
            cell.lastMessageUser.text = chats[indexPath.row].lastMessage ?? ""
            cell.lastMessageDateUser.text = chats[indexPath.row].timeToNow ?? "nil"
            
            if let url = chats[indexPath.row].firstUserImage {
                if url.isValidHttpsUrl {
                    Nuke.loadImage(with: URL(string: url)!, into: cell.imageUser)
                }
            }
            
            
        }
        
        cell.imageUser.layer.cornerRadius = cell.imageUser.frame.size.width/2
        cell.imageUser.layer.masksToBounds = true
    

        return(cell)
        
    }
    
    
}
