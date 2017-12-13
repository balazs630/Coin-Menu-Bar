//
//  CryptoCurrencyViewController.swift
//  LitecoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class CryptoCurrencyViewController: NSViewController {
    
    @IBOutlet weak var fiatCurrencyPicker: NSPopUpButton!
    @IBOutlet weak var cryptoCurrencyPicker: NSPopUpButton!
    
    @IBOutlet weak var chkExchangeRateWatcher: NSButton!
    @IBOutlet weak var txtThreshold: NSTextField!
    @IBOutlet weak var lblActualCurrency: NSTextField!

    let cryptoCurrencyMonitor = CryptoCurrencyMonitor()
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
                defaults.set(true, forKey: UserDefaultsKeys.isExchangeRateWatcherOn)
            }
            defaults.synchronize()
        }
    }
    
    override func viewDidAppear() {
        txtThreshold.doubleValue = exchangeRateThreshold
        chkExchangeRateWatcher.state = isExchangeRateWatcherOn
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        cryptoCurrencyMonitor.getCurrentExchangeRate()
    }
    
    @IBAction func quitBtnPressed(_ sender: Any) {
        NSApplication.shared.terminate(sender)
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
