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
    
    private var coreDataStack: CoreDataStack?
    
    override init() {
        self.db = Firestore.firestore()
        if let app = UIApplication.shared.delegate as? AppDelegate {
            self.coreDataStack = app.coreDataStack
        }
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
    
    public func getChannelUpdateListener(completion: @escaping ([Channel]) -> Void) -> ListenerRegistration? {
        let reference = getReference(for: .allChannels)
        return reference.addSnapshotListener { snapshot, _ in
            if let documents = snapshot?.documents {
                var result: [Channel] = []
                for document in documents {
                    let documentData = document.data()
                    if documentData["name"] != nil {
                        let dateTimeStamp = documentData["lastActivity"] as? Timestamp
                        let channel = Channel(identifier: document.documentID,
                                              name: documentData["name"] as? String ?? "Unknown Name",
                                              lastMessage: documentData["lastMessage"] as? String,
                                              lastActivity: dateTimeStamp?.dateValue())
                        result.append(channel)
                        
                        self.coreDataStack?.performSave { context in
                            let ch = ChannelDb(context: context)
                            ch.identifier = document.documentID
                            ch.name = documentData["name"] as? String ?? "Unknown Name"
                            ch.lastMessage = documentData["lastMessage"] as? String
                            ch.lastActivity = dateTimeStamp?.dateValue()
                        }
                    }
                }
                completion(result.sort())
            }
        }
    }
    
    public func getMessageUpdateListener(for channelId: String,
                                         completion: @escaping ([Message]) -> Void) -> ListenerRegistration? {
        let reference = getReference(for: .channel(channelId))
        return reference.addSnapshotListener { snapshot, _ in
            if let documents = snapshot?.documents {
                var result: [Message] = []
                for document in documents {
                    let documentData = document.data()
                    let messageDate = documentData["created"] as? Timestamp
                    let message = Message(content: documentData["content"] as? String ?? "",
                                          created: messageDate?.dateValue() ?? Date(),
                                          senderId: documentData["senderId"] as? String ?? "",
                                          senderName: documentData["senderName"] as? String ?? "Unknown Name")
                    result.append(message)
                }
                completion(result.sort())
            }
        }
    }
    
    public func addChannel(channelName: String) {
        let reference = getReference(for: .allChannels)
        let channel: [String: Any] = [
            "name": channelName
        ]
        reference.addDocument(data: channel,
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
