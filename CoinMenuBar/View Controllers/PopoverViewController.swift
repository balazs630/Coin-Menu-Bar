//
//  PopoverViewController.swift
//  CoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {

    // MARK: Properties
    let defaults = UserDefaults.standard
    let cryptoCurrencyMonitor: CryptoCurrencyMonitor

    var cryptoCurrency: String {
        get {
            return defaults.string(forKey: UserDefaults.Key.cryptoCurrency)!
        }
        set(newVal) {
            defaults.set(newVal, forKey: UserDefaults.Key.cryptoCurrency)
            defaults.synchronize()
        }
    }

    var fiatCurrency: String {
        get {
            return defaults.string(forKey: UserDefaults.Key.fiatCurrency)!
        }
        set(newVal) {
            defaults.set(newVal, forKey: UserDefaults.Key.fiatCurrency)
            defaults.synchronize()
        }
    }

    var exchangeRateThreshold: String {
        get {
            return defaults.string(forKey: UserDefaults.Key.exchangeRateThreshold)!
        }
        set(newVal) {
            defaults.set(newVal, forKey: UserDefaults.Key.exchangeRateThreshold)
            defaults.synchronize()
        }
    }

    var isExchangeRateWatcherOn: NSControl.StateValue {
        get {
            if defaults.bool(forKey: UserDefaults.Key.isExchangeRateWatcherOn) {
                return NSControl.StateValue.on
            } else {
                return NSControl.StateValue.off
            }
        }
        set(newVal) {
            chkExchangeRateWatcher.state = newVal
            if newVal == NSControl.StateValue.on {
                defaults.set(true, forKey: UserDefaults.Key.isExchangeRateWatcherOn)
            } else {
                defaults.set(false, forKey: UserDefaults.Key.isExchangeRateWatcherOn)
            }
            defaults.synchronize()
        }
    }

    // MARK: Outlets
    @IBOutlet weak var pckFiatCurrency: NSPopUpButton!
    @IBOutlet weak var pckCryptoCurrency: NSPopUpButton!

    @IBOutlet weak var chkExchangeRateWatcher: NSButton!
    @IBOutlet weak var txtThreshold: NSTextField!
    @IBOutlet weak var lblActualCurrency: NSTextField!

    // MARK: Initializers
    required init?(coder: NSCoder) {
        cryptoCurrencyMonitor = CryptoCurrencyMonitor()
        super.init(coder: coder)

        cryptoCurrencyMonitor.getCurrentExchangeRate()
        cryptoCurrencyMonitor.setRepeatingDataFetcher()
    }

    // MARK: - View lifecycle
    override func viewDidAppear() {
        setupView()
    }

    static func instantiateController() -> PopoverViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name.main, bundle: nil)
        let popoverId = NSStoryboard.SceneIdentifier.popoverVC
        guard let popover = storyboard.instantiateController(withIdentifier: popoverId) as? PopoverViewController else {
            fatalError("Could not instantiate PopoverViewController with Storyboard ID: \(popoverId)")
        }
        return popover
    }
}

// MARK: Screen setup
extension PopoverViewController {
    private func setupView() {
        chkExchangeRateWatcher.state = isExchangeRateWatcherOn
        txtThreshold.isEnabled = defaults.bool(forKey: UserDefaults.Key.isExchangeRateWatcherOn)
        txtThreshold.stringValue = exchangeRateThreshold
        lblActualCurrency.stringValue = fiatCurrency
        pckFiatCurrency.selectItem(withTitle: fiatCurrency)
        pckCryptoCurrency.selectItem(withTitle: cryptoCurrency)
    }
}

// MARK: - Actions
extension PopoverViewController {
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

    @IBAction func updateButtonPressed(_ sender: Any) {
        cryptoCurrencyMonitor.getCurrentExchangeRate()
    }

    @IBAction func quitButtonPressed(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
}

// MARK: - NSControlTextEditingDelegate methods
extension PopoverViewController: NSTextFieldDelegate {
     func controlTextDidChange(_ notification: Notification) {
        guard let actualInput = (notification.object as? NSTextField)?.stringValue else { return }
        if exchangeRateThreshold != actualInput {
            exchangeRateThreshold = actualInput.filterNumbers(upto: 6, isDouble: true)
        }
    }
}
