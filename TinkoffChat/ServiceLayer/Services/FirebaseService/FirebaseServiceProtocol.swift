//
//  FirebaseServiceProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

protocol FirebaseServiceProtocol {
    func getChannels(completion: @escaping () -> Void)
    func deleteChannel(_ channel: ChannelDb)
    func createChannel(channelName: String)
    func getMessages(channelId: String, completion: @escaping () -> Void)
    func sendMessage(channelId: String,
                     messageText: String,
                     complition: @escaping (Bool) -> Void)
}
