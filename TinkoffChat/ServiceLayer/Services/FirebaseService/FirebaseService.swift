//
//  FirebaseService.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation
import Firebase

class FirebaseService: FirebaseServiceProtocol {
    
    private lazy var db = Firestore.firestore()
    
    private let backgroundQueue = DispatchQueue(label: "ru.tinkoff.TinkoffChat.FirebaseService",
                                                qos: .userInitiated)
    
    private let parserService: FirebaseParserProtocol
    private let coreDataService: CoreDataManagerProtocol
    private let settingsService: SettingsServiceProtocol
    private let profileService: ProfileServiceProtocol
    
    init(parserService: FirebaseParserProtocol,
         coreDataService: CoreDataManagerProtocol,
         settingsService: SettingsServiceProtocol,
         profileService: ProfileServiceProtocol) {
        
        self.parserService = parserService
        self.coreDataService = coreDataService
        self.settingsService = settingsService
        self.profileService = profileService
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
    
    func getChannels(completion: @escaping () -> Void) {
        let reference = getReference(for: .allChannels)
        backgroundQueue.async {
            reference.addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(String(describing: error))")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        self.parserService.parseNewChannel(diff: diff)
                    case .modified:
                        self.parserService.parseUpdateChannel(diff: diff)
                    case .removed:
                        self.coreDataService.deleteChannel(channelId: diff.document.documentID)
                    }
                    completion()
                }
            }
        }
    }
    
    func getMessages(channelId: String, completion: @escaping () -> Void) {
        let reference = getReference(for: .channel(channelId))
        
        backgroundQueue.async {
            reference.addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(String(describing: error))")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        self.parserService.parseNewMessage(channelId: channelId, diff: diff)
                    case .modified:
                        break
                    case .removed:
                        break
                    }
                    
                    completion()
                }
            }
        }
    }
    
    public func createChannel(channelName: String) {
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
    
    public func deleteChannel(_ channel: ChannelDb) {
        guard let id = channel.identifier else { return }
        let reference = getReference(for: .allChannels).document(id)
        reference.delete(completion: { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                self.coreDataService.deleteChannel(channelId: id)
            }
        })
    }
    
    public func sendMessage(channelId: String,
                            messageText: String,
                            complition: @escaping (Bool) -> Void) {
        
        let reference = getReference(for: .channel(channelId))
        
        if let deviceId = settingsService.getDeviceId() {
            profileService.getUserProfile(completionHandler: { (profile, error) in
                if let error = error {
                    print(error.localizedDescription)
                    complition(false)
                }
                
                let message: [String: Any] = [
                    "content": messageText,
                    "created": Date(),
                    "senderId": deviceId,
                    "senderName": profile?.userName ?? "Unknown User"
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
            })
        }
    }
}
