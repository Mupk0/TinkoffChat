//
//  NetworkService.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 21.03.2021.
//

import Foundation
import FirebaseFirestore

class NetworkService: NSObject {
    
    static let shared = NetworkService()
    
    private let db: Firestore
    
    var didGetChannels: (([Channel]) -> Void)?
    var didGetMessages: (([Message]) -> Void)?
    
    override init() {
        self.db = Firestore.firestore()
    }
    
    private enum NetworkCollection {
        case allChannels
        case channel(String)
    }
    
    private func getReference(for collection: NetworkCollection) -> CollectionReference {
        switch collection {
        case .allChannels:
            return db.collection("channels")
        case .channel(let channelId):
            return db.collection("channels").document(channelId).collection("messages")
        }
    }
    
    public func addChannelUpdateListener() {
        var result: [Channel] = []
        
        let reference = getReference(for: .allChannels)
        reference.addSnapshotListener { [weak self] snapshot, _ in
            if let documents = snapshot?.documents {
                for document in documents {
                    let doc = document.data()
                    if doc["name"] != nil {
                        let dateTimeStamp = doc["lastActivity"] as? Timestamp
                        let channel = Channel(identifier: document.documentID,
                                              name: doc["name"] as? String,
                                              lastMessage: doc["lastMessage"] as? String,
                                              lastActivity: dateTimeStamp?.dateValue())
                        result.append(channel)
                    }
                }
            }
            self?.didGetChannels?(result.sort())
        }
    }
    
    public func addMessageUpdateListener(for channelId: String) {
        var result: [Message] = []
    
        let reference = getReference(for: .channel(channelId))
        
        reference.addSnapshotListener { [weak self] snapshot, _ in
            if let documents = snapshot?.documents {
                for document in documents {
                    let doc = document.data()
                    let messageDate = doc["created"] as? Timestamp
                    let message = Message(content: doc["content"] as? String,
                                          created: messageDate?.dateValue(),
                                          senderId: doc["senderId"] as? String,
                                          senderName: doc["senderName"] as? String)
                    result.append(message)
                }
            }
            self?.didGetMessages?(result.sort())
        }
    }
    
    public func addChannel(channelName: String) {
        let reference = getReference(for: .allChannels).document()
        let channel: [String: Any] = [
            "identifier": reference.documentID,
            "name": channelName
        ]
        reference.setData(channel,
                          completion: { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                          })
    }
    
    public func addMessage(channelId: String,
                           messageText: String,
                           complition: @escaping (Bool) -> Void) {
        
        let reference = getReference(for: .channel(channelId))

        if let deviceId = Settings.shared.deviceId {
            ProfileFileStorage().load { profile in
                let message: [String: Any] = [
                    "content": messageText,
                    "created": Date(),
                    "senderId": deviceId,
                    "senderName": profile?.userName ?? "Unknown Name"
                ]
                
                reference.addDocument(data: message,
                                      completion: { error in
                                        if let error = error {
                                            print(error.localizedDescription)
                                            complition(false)
                                        } else {
                                            complition(true)
                                        }
                                      })
            }
        }
    }
}
