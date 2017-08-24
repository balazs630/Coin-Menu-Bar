//
//  CryptoCurrencyAPI.swift
//  LitecoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Foundation

class CryptoCurrencyAPI {

    func fetchExchangeRate(from cryproCurrency: String, to realCurrency: String, success: @escaping (Double) -> Void) {
        let BASE_URL = "https://min-api.cryptocompare.com/data/"
        let session = URLSession.shared
        let url = URL(string: "\(BASE_URL)pricemulti?fsyms=\(cryproCurrency)&tsyms=\(realCurrency)")

        let task = session.dataTask(with: url!) { data, response, err in
            if let error = err {
                NSLog("cryptocompare api error: \(error)")
            }

            // Check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    if let exchangeRate = self.exchangeRateFromJSONData(data!, from: cryproCurrency, to: realCurrency) {
                        success(exchangeRate)
                    }
                case 400...499:
                    NSLog("cryptocompare API returned Client Error response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                case 500...599:
                    NSLog("cryptocompare API returned Server Error response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                default:
                    NSLog("cryptocompare API returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }

    func exchangeRateFromJSONData(_ data: Data, from cryproCurrency: String, to realCurrency: String) -> Double? {
        typealias JSONDict = [String: Any]
        let json: JSONDict

        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }

        var currency = json[cryproCurrency] as! JSONDict
        let exchangeRate = currency[realCurrency] as! Double

        return exchangeRate
    }
}
