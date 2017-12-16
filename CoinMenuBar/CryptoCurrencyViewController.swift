//
//  CryptoCurrencyViewController.swift
//  LitecoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class CryptoCurrencyViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var pckFiatCurrency: NSPopUpButton!
    @IBOutlet weak var pckCryptoCurrency: NSPopUpButton!
    
    @IBOutlet weak var chkExchangeRateWatcher: NSButton!
    @IBOutlet weak var txtThreshold: NSTextField!
    @IBOutlet weak var lblActualCurrency: NSTextField!

    let cryptoCurrencyMonitor = CryptoCurrencyMonitor()
    var defaults: UserDefaults = UserDefaults.standard
    
    var cryptoCurrency: String {
        get {
            return defaults.string(forKey: UserDefaultsKeys.cryptoCurrency)!
        }
        set(newVal) {
            defaults.set(newVal, forKey: UserDefaultsKeys.cryptoCurrency)
            defaults.synchronize()
        }
    }
    
    var fiatCurrency: String {
        get {
            return defaults.string(forKey: UserDefaultsKeys.fiatCurrency)!
        }
        set(newVal) {
            defaults.set(newVal, forKey: UserDefaultsKeys.fiatCurrency)
            defaults.synchronize()
        }
    }
    
    var exchangeRateThreshold: String {
        get {
            return defaults.string(forKey: UserDefaultsKeys.exchangeRateThreshold)!
        }
        set(newVal) {
            defaults.set(newVal, forKey: UserDefaultsKeys.exchangeRateThreshold)
            defaults.synchronize()
        }
    }
    
    var isExchangeRateWatcherOn: NSControl.StateValue {
        get {
            if defaults.bool(forKey: UserDefaultsKeys.isExchangeRateWatcherOn) {
                return NSControl.StateValue.on
            } else {
                return NSControl.StateValue.off
            }
        }
        set(newVal) {
            chkExchangeRateWatcher.state = newVal
            if newVal == NSControl.StateValue.on {
                defaults.set(true, forKey: UserDefaultsKeys.isExchangeRateWatcherOn)
            } else {
                defaults.set(false, forKey: UserDefaultsKeys.isExchangeRateWatcherOn)
            }
            defaults.synchronize()
        }
    }
    
    override func viewDidAppear() {
        chkExchangeRateWatcher.state = isExchangeRateWatcherOn
        txtThreshold.isEnabled = defaults.bool(forKey: UserDefaultsKeys.isExchangeRateWatcherOn)
        txtThreshold.stringValue = exchangeRateThreshold
        pckFiatCurrency.selectItem(withTitle: fiatCurrency)
        pckCryptoCurrency.selectItem(withTitle: cryptoCurrency)
    }
    
    @IBAction func fiatCurrencySelectionDidChange(_ sender: NSPopUpButton) {
        if fiatCurrency != sender.selectedItem!.title {
            fiatCurrency = sender.selectedItem!.title
            cryptoCurrencyMonitor.getCurrentExchangeRate()
            lblActualCurrency.stringValue = sender.selectedItem!.title
        }
    }
    
    @IBAction func cryptoCurrencySelectionDidChange(_ sender: NSPopUpButton) {
        if cryptoCurrency != sender.selectedItem!.title {
            cryptoCurrency = sender.selectedItem!.title
            cryptoCurrencyMonitor.getCurrentExchangeRate()
        }
    }
    
    @IBAction func exchangeRateWatcherCheckBoxClicked(_ sender: NSButton) {
        if sender.state == NSControl.StateValue.on {
            isExchangeRateWatcherOn = NSControl.StateValue.on
            txtThreshold.isEnabled = true
        } else {
            isExchangeRateWatcherOn = NSControl.StateValue.off
            txtThreshold.isEnabled = false
        }
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        cryptoCurrencyMonitor.getCurrentExchangeRate()
    }
    
    @IBAction func quitBtnPressed(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
    override func controlTextDidChange(_ notification: Notification) {
        let actualInput = ((notification.object as? NSTextField)?.stringValue)!
        if exchangeRateThreshold != actualInput {
            exchangeRateThreshold = actualInput.filterNumbers(upto: 6, isDouble: true)
        }
    }
    
}

extension CryptoCurrencyViewController {
    
    // Storyboard instantiation
    static func instantiateController() -> CryptoCurrencyViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "CryptoCurrencyViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? CryptoCurrencyViewController else {
            fatalError("Check Main.storyboard")
        }
        return viewcontroller
    }
}
