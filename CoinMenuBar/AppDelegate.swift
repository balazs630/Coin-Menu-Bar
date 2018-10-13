//
//  AppDelegate.swift
//  CoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject {
    // MARK: Properties
    let defaults = UserDefaults.standard
    let statusItem: NSStatusItem
    let popover: NSPopover

    // MARK: Initializers
    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.title = "---/---: ----"
        statusItem.action = #selector(togglePopover)

        popover = NSPopover()
        popover.contentViewController = PopoverViewController.instantiateController()
    }
}

// MARK: - NSApplicationDelegate conformances
extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initUserDefaults()
    }
}

// MARK: - UserDefaults setup
extension AppDelegate {
    private func initUserDefaults() {
        if defaults.object(forKey: UserDefaults.Key.isAppAlreadyLaunchedOnce) == nil {
            setFirstLaunchDefaultSettings()
        }
    }

    private func setFirstLaunchDefaultSettings() {
        let firstTimeLaunchDefaults: [String: Any] = [
            UserDefaults.Key.isAppAlreadyLaunchedOnce: true,
            UserDefaults.Key.cryptoCurrency: CryptoCurrency.Litecoin.code,
            UserDefaults.Key.fiatCurrency: FiatCurrency.Euro.code,
            UserDefaults.Key.exchangeRateThreshold: "500",
            UserDefaults.Key.isExchangeRateWatcherOn: false
        ]

        firstTimeLaunchDefaults.forEach {
            defaults.set($0.value, forKey: $0.key)
        }

        defaults.synchronize()
    }
}

// MARK: - Click actions
extension AppDelegate {
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.performOpen(statusItem: statusItem)
        }
    }
}
