//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 11.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Log.show(message: "\(className) calls")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Log.show(message: "\(className) calls")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Log.show(message: "\(className) calls")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        Log.show(message: "\(className) calls")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Log.show(message: "\(className) calls")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Log.show(message: "\(className) calls")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Log.show(message: "\(className) calls")
    }
}
