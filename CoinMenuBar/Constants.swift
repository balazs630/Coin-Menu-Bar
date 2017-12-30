//
//  Constants.swift
//  Litecoin Menu Bar
//
//  Created by Horváth Balázs on 2017. 12. 11..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Foundation

struct FiatCurrency {
    struct Forint {
        static let name = "forint"
        static let sign = "Ft"
        static let code = "HUF"
    }
    
    struct Euro {
        static let name = "euro"
        static let sign = "€"
        static let code = "EUR"
    }
    
    struct Dollar {
        static let name = "dollar"
        static let sign = "$"
        static let code = "USD"
    }
}

struct CryptoCurrency {
    struct Litecoin {
        static let name = "litecoin"
        static let code = "LTC"
    }
}

extension UserDefaults {
    struct Key {
        static let isAppAlreadyLaunchedOnce = "isAppAlreadyLaunchedOnce"
        static let cryptoCurrency = "cryptoCurrency"
        static let fiatCurrency = "fiatCurrency"
        static let exchangeRateThreshold = "exchangeRateThreshold"
        static let isExchangeRateWatcherOn = "isExchangeRateWatcherOn"
    }
}

