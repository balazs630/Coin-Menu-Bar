//
//  CryptoCurrencyMonitor.swift
//  LitecoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 29..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class CryptoCurrencyMonitor: NSObject {
    
    let cryptoCurrencyAPI = CryptoCurrencyAPI()
    var defaults: UserDefaults = UserDefaults.standard
    
    var cryptoCurrency: String {
        return defaults.string(forKey: UserDefaultsKeys.cryptoCurrency)!
    }
    
    var fiatCurrency: String {
        return defaults.string(forKey: UserDefaultsKeys.fiatCurrency)!
    }
    
    var exchangeRateThreshold: Double {
        return defaults.double(forKey: UserDefaultsKeys.exchangeRateThreshold)
    }
    
    var isExchangeRateWatcherOn: Bool {
        return defaults.bool(forKey: UserDefaultsKeys.isExchangeRateWatcherOn)
    }
    
    func getCurrentExchangeRate() {
        cryptoCurrencyAPI.fetchExchangeRate(from: cryptoCurrency, to: fiatCurrency) { exchangeRate in
            self.updateUIElements(by: exchangeRate)
        }
    }
    
    func updateUIElements(by exchangeRate: Double) {
        // Do UI updates on the main thread
        DispatchQueue.main.async {
            // For example "LTC\EUR: 44.56
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.statusItem.title = "\(self.cryptoCurrency)\\\(self.fiatCurrency): \(exchangeRate)"
        }
        
        if isExchangeRateWatcherOn && isThresholdExceeded(basedOn: exchangeRate) == true {
            sendThresholdExceededNotification()
        }
    }
    
    func isThresholdExceeded(basedOn exchangeRate: Double) -> Bool {
        if exchangeRate >= exchangeRateThreshold {
            return true
        } else {
            return false
        }
    }
    
    func sendThresholdExceededNotification() {
        let notification = NSUserNotification()
        notification.title = "Threshold exceeded"
        notification.informativeText = "Exchange rate for \(cryptoCurrency) exceeded \(exchangeRateThreshold) \(fiatCurrency)."
        NSUserNotificationCenter.default.deliver(notification)
    }
    
}
