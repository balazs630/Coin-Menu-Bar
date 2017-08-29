//
//  CryptoCurrencyViewController.swift
//  LitecoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class CryptoCurrencyViewController: NSViewController {

    let cryptoCurrencyMonitor = CryptoCurrencyMonitor()

    @IBAction func updateBtnPressed(_ sender: Any) {
        cryptoCurrencyMonitor.getCurrentExchangeRate()
    }

}

extension CryptoCurrencyViewController {

    // Storyboard instantiation
    static func instantiateController() -> CryptoCurrencyViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: "CryptoCurrencyViewController") as? CryptoCurrencyViewController else {
            fatalError("Check Main.storyboard")
        }
        return viewcontroller
    }
}
