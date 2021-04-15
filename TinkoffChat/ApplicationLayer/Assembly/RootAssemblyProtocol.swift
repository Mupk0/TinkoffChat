//
//  RootAssemblyProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.04.2021.
//

import Foundation

protocol RootAssemblyProtocol {
    var presentationAssembly: PresentationAssemblyProtocol { get }
    var serviceAssembly: ServicesAssemblyProtocol { get }
    var coreAssembly: CoreAssemblyProtocol { get }
}
