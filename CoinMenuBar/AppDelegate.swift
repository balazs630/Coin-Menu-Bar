//
//  AppDelegate.swift
//  CoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem: NSStatusItem
    let popover: NSPopover

    let cryptoCurrencyMonitor = CryptoCurrencyMonitor()
    var timer = Timer()

    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.title = "---/---: ----"
        statusItem.action = #selector(togglePopover)

        popover = NSPopover()
        popover.contentViewController = CryptoCurrencyViewController.instantiateController()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let defaults = UserDefaults.standard

        if defaults.object(forKey: UserDefaults.Key.isAppAlreadyLaunchedOnce) == nil {
            // First launch

            let firstTimeLaunchDefaults: [String: Any] = [
                UserDefaults.Key.isAppAlreadyLaunchedOnce: true,
                UserDefaults.Key.cryptoCurrency: CryptoCurrency.Litecoin.code,
                UserDefaults.Key.fiatCurrency: FiatCurrency.Euro.code,
                UserDefaults.Key.exchangeRateThreshold: "500",
                UserDefaults.Key.isExchangeRateWatcherOn: false
            ]

            for item in firstTimeLaunchDefaults {
                defaults.set(item.value, forKey: item.key)
            }

            defaults.synchronize()
        }

        // Update data on first launch
        updateData()

        // Set timer to fetch data every 30 seconds
        timer = Timer.scheduledTimer(timeInterval: 30.0,
                                     target: self,
                                     selector: #selector(updateData),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc func updateData() {
        cryptoCurrencyMonitor.getCurrentExchangeRate()
    }

    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            // Close popover
            popover.performClose(sender)
        } else {
            // Show popover
            if let button = statusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }

}
