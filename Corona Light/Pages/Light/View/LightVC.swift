//
//  LightVC.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import UIKit

enum State {
    case darkRed
    case red
    case yellow
    case green
}

class LightVC: UIViewController {
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello world!!")
        self.view.backgroundColor = .white
    }
}
