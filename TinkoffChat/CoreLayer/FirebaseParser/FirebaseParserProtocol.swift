//
//  FirebaseParserProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation
import Firebase

protocol FirebaseParserProtocol {
    func parseNewChannel(diff: DocumentChange)
    func parseUpdateChannel(diff: DocumentChange)
    func parseNewMessage(channelId: String, diff: DocumentChange)
}
