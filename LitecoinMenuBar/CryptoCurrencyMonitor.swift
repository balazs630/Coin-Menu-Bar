//
//  CryptoCurrencyMonitor.swift
//  LitecoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 29..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class CryptoCurrencyMonitor: NSObject {

    let cryptoCurrency = "LTC"
    let realCurrency = "EUR"

    let cryptoCurrencyAPI = CryptoCurrencyAPI()

    func getCurrentExchangeRate() {
        cryptoCurrencyAPI.fetchExchangeRate(from: cryptoCurrency, to: realCurrency) { exchangeRate in
            self.updateUIElements(exchangeRate)
        }
    }

    func updateUIElements(_ exchangeRate: Double) {
        // Do UI updates on the main thread
        DispatchQueue.main.async {
            // For example "LTC\EUR: 44.56
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.statusItem.title = "\(self.cryptoCurrency)\\\(self.realCurrency): \(exchangeRate)"
        }
    }

}
