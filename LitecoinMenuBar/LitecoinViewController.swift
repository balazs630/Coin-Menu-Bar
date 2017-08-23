//
//  LitecoinViewController.swift
//  LitecoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class LitecoinViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    @IBAction func refreshBtnClicked(_ sender: Any) {
        CryptoCurrencyAPI.fetchExchangeRate(from: "LTC", to: "EUR")
    }
}

extension LitecoinViewController {

    // MARK: Storyboard instantiation
    static func freshController() -> LitecoinViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: "LitecoinViewController") as? LitecoinViewController else {
            fatalError("Check Main.storyboard")
        }
        return viewcontroller
    }
}
