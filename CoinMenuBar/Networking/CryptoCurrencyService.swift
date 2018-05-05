//
//  CryptoCurrencyService.swift
//  CoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Alamofire

class CryptoCurrencyService {

    let baseUrl = "https://min-api.cryptocompare.com/data/"

    func fetchExchangeRate(from cryptoCurrency: String, to fiatCurrency: String, success: @escaping (Double) -> Void) {
        guard let requestUrl = URL(string: "\(baseUrl)pricemulti?fsyms=\(cryptoCurrency)&tsyms=\(fiatCurrency)") else {
            return
        }

        Alamofire.request(requestUrl, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                let exchangeRate = self.getExchangeRate(json: response.toJson(), from: cryptoCurrency, to: fiatCurrency)
                success(exchangeRate)

            case .failure(let error):
                NSLog(error.localizedDescription)
            }
        }
    }

    private func getExchangeRate(json: NSDictionary, from cryptoCurrency: String, to fiatCurrency: String) -> Double {
        // HACK: The crypto currency value is a key in the json, unable to write a Codable model for the response
        guard let currency = json[cryptoCurrency] as? NSDictionary else {
            fatalError("Cannot find \(cryptoCurrency) key!")
        }

        guard let exchangeRate = currency[fiatCurrency] as? Double else {
            fatalError("Cannot find \(fiatCurrency) key for \(cryptoCurrency)!")
        }

        return exchangeRate
    }
}
