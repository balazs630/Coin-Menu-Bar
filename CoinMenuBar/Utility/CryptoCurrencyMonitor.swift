//
//  CryptoCurrencyMonitor.swift
//  CoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 29..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class CryptoCurrencyMonitor {

    // MARK: Properties
    var timer = Timer()
    let defaults = UserDefaults.standard
    let cryptoCurrencyService: CryptoCurrencyService

    var cryptoCurrency: String {
        return defaults.string(forKey: UserDefaults.Key.cryptoCurrency)!
    }

    var fiatCurrency: String {
        return defaults.string(forKey: UserDefaults.Key.fiatCurrency)!
    }

    var exchangeRateThreshold: Double {
        return defaults.double(forKey: UserDefaults.Key.exchangeRateThreshold)
    }

    var isExchangeRateWatcherOn: Bool {
        get {
            return defaults.bool(forKey: UserDefaults.Key.isExchangeRateWatcherOn)
        }
        set(newVal) {
            defaults.set(newVal, forKey: UserDefaults.Key.isExchangeRateWatcherOn)
            defaults.synchronize()
        }
    }

    // MARK: Initializers
    init() {
        self.cryptoCurrencyService = CryptoCurrencyService()
    }

    // MARK: Utility methods
    func setRepeatingDataFetcher() {
        timer = Timer.scheduledTimer(timeInterval: Constant.dataFetcherTimerInterval,
                                     target: self,
                                     selector: #selector(getCurrentExchangeRate),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc func getCurrentExchangeRate() {
        cryptoCurrencyService.fetchExchangeRate(from: cryptoCurrency, to: fiatCurrency) { exchangeRate in
            self.updateMenuBarStatusElement(by: exchangeRate)
            self.compareThreshold(with: exchangeRate)
        }
    }

    private func updateMenuBarStatusElement(by exchangeRate: Double) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
        DispatchQueue.main.async {
            // For example "LTC\EUR: 44.56
            let formattedRate = String(format: "%.4f", exchangeRate)
            appDelegate.statusItem.title = "\(self.cryptoCurrency)\\\(self.fiatCurrency): \(formattedRate)"
        }
    }

    private func compareThreshold(with exchangeRate: Double) {
        if isExchangeRateWatcherOn && isThresholdExceeded(basedOn: exchangeRate) {
            sendThresholdExceededNotification()
            isExchangeRateWatcherOn = false
        }
    }

    private func isThresholdExceeded(basedOn exchangeRate: Double) -> Bool {
        return exchangeRate >= exchangeRateThreshold
    }

    private func sendThresholdExceededNotification() {
        let notification = NSUserNotification()
        notification.title = "Threshold exceeded"
        notification.informativeText = "Exchange rate for \(cryptoCurrency)"
                                        + "exceeded \(exchangeRateThreshold) \(fiatCurrency)."
        NSUserNotificationCenter.default.deliver(notification)
    }

}
