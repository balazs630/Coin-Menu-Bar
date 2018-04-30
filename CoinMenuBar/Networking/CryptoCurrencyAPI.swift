//
//  CryptoCurrencyAPI.swift
//  CoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Foundation

class CryptoCurrencyAPI {

    func fetchExchangeRate(from cryptoCurrency: String, to fiatCurrency: String, success: @escaping (Double) -> Void) {
        let baseUrl = "https://min-api.cryptocompare.com/data/"
        guard let url = URL(string: "\(baseUrl)pricemulti?fsyms=\(cryptoCurrency)&tsyms=\(fiatCurrency)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, err in
            if let error = err {
                NSLog("cryptocompare api error: \(error)")
            }

            // Check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    guard let data = data else { return }
                    if let exchangeRate = self.exchangeRateFromJSONData(data, from: cryptoCurrency, to: fiatCurrency) {
                        success(exchangeRate)
                    }
                default:
                    NSLog(HTTPResponse.init(statusCode: httpResponse.statusCode).description)
                }
            }
        }
        task.resume()
    }

    func exchangeRateFromJSONData(_ data: Data, from cryptoCurrency: String, to fiatCurrency: String) -> Double? {
        var json = [String: Any]()

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            if let jsonDictionary = jsonObject as? [String: Any] {
                json = jsonDictionary
            }
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }

        guard let currency = json[cryptoCurrency] as? [String: Any] else {
            return nil
        }

        guard let exchangeRate = currency[fiatCurrency] as? Double else {
            return nil
        }

        return exchangeRate
    }
}

struct HTTPResponse: CustomStringConvertible {
    var statusCode: Int

    var description: String {
        var errorDescription: String

        switch statusCode {
        case 300...399:
            errorDescription = "Redirection"
        case 400...499:
            errorDescription = "Client Error"
        case 500...599:
            errorDescription = "Server Error"
        default:
            errorDescription = ""
        }

        return "cryptocompare API returned response with status code: "
            + "\(statusCode) \(errorDescription) \(HTTPURLResponse.localizedString(forStatusCode: statusCode)) "
    }
}
