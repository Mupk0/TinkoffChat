//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

class RootAssembly: RootAssemblyProtocol {
    lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: serviceAssembly)
    lazy var serviceAssembly: ServicesAssemblyProtocol = ServicesAssembly(coreAssembly: coreAssembly)
    lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
}
