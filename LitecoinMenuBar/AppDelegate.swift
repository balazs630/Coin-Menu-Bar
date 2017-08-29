//
//  AppDelegate.swift
//  LitecoinMenuBar
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
        statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        statusItem.title = "---/---: ----"
        statusItem.action = #selector(togglePopover)

        popover = NSPopover()
        popover.contentViewController = CryptoCurrencyViewController.instantiateController()
    }

    func updateData() {
        NSLog("update data")
        cryptoCurrencyMonitor.getCurrentExchangeRate()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        // Update data on first launch
        updateData()

        // Set timer to fetch data every 30 seconds
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

// Actions
extension AppDelegate {

    func togglePopover(_ sender: Any?) {
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
