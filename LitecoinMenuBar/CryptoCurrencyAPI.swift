//
//  CryptoCurrencyAPI.swift
//  LitecoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Foundation

class CryptoCurrencyAPI {

    class func fetchExchangeRate(from cryproCurrency: String, to realCurrency: String) {
        let BASE_URL = "https://min-api.cryptocompare.com/data/"
        let session = URLSession.shared
        let url = URL(string: "\(BASE_URL)pricemulti?fsyms=\(cryproCurrency)&tsyms=\(realCurrency)")

        let task = session.dataTask(with: url!, completionHandler: { data, response, err -> Void in
            if let error = err {
                NSLog("cryptocompare api error: \(error)")
            }

            // Check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let jsonResponseData = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                        let currency = jsonResponseData[cryproCurrency] as! NSDictionary
                        let exchangeRate = currency[realCurrency] as! Double
                        print("1\(cryproCurrency) = \(exchangeRate)\(realCurrency)")
                    } catch {
                        print("Error deserializing JSON: \(error)")
                    }

                default:
                    NSLog("cryptocompare API returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        })
        task.resume()
    }
}
