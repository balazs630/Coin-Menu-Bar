//
//  Constants.swift
//  CoinMenuBar
//
//  Created by Horváth Balázs on 2017. 12. 11..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Cocoa

struct FiatCurrency {
    enum Forint {
        static let name = "forint"
        static let sign = "Ft"
        static let code = "HUF"
    }

    enum Euro {
        static let name = "euro"
        static let sign = "€"
        static let code = "EUR"
    }

    enum Dollar {
        static let name = "dollar"
        static let sign = "$"
        static let code = "USD"
    }
}

struct CryptoCurrency {
    enum Litecoin {
        static let name = "litecoin"
        static let code = "LTC"
    }
}

extension UserDefaults {
    enum Key {
        static let isAppAlreadyLaunchedOnce = "isAppAlreadyLaunchedOnce"
        static let cryptoCurrency = "cryptoCurrency"
        static let fiatCurrency = "fiatCurrency"
        static let exchangeRateThreshold = "exchangeRateThreshold"
        static let isExchangeRateWatcherOn = "isExchangeRateWatcherOn"
    }
}

extension NSStoryboard.Name {
    static let main = NSStoryboard.Name(rawValue: "Main")
}

extension NSStoryboard.SceneIdentifier {
    static let popoverVC = NSStoryboard.SceneIdentifier(rawValue: "PopoverViewController")
}
