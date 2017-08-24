//
//  CryptoCurrencyViewController.swift
//  LitecoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class CryptoCurrencyViewController: NSViewController {

    let cryptoCurrency = "LTC"
    let realCurrency = "EUR"

    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    let cryptoCurrencyAPI = CryptoCurrencyAPI()

    @IBAction func getCurrentExchangeRate(_ sender: Any) {
        cryptoCurrencyAPI.fetchExchangeRate(from: cryptoCurrency, to: realCurrency) { exchangeRate in
            self.updateUIElements(exchangeRate)
        }
    }

    func updateUIElements(_ exchangeRate: Double) {
        // Do UI updates on the main thread
        DispatchQueue.main.async {
            // For example "LTC\EUR: 44.56
            self.appDelegate.statusItem.title = "\(self.cryptoCurrency)\\\(self.realCurrency): \(exchangeRate)"
        }
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
