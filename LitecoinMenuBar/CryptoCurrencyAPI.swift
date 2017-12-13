//
//  CryptoCurrencyAPI.swift
//  LitecoinMenuBar
//
//  Created by Horváth Balázs on 2017. 08. 23..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Foundation

class CryptoCurrencyAPI {
    
    func fetchExchangeRate(from cryproCurrency: String, to fiatCurrency: String, success: @escaping (Double) -> Void) {
        let BASE_URL = "https://min-api.cryptocompare.com/data/"
        let session = URLSession.shared
        let url = URL(string: "\(BASE_URL)pricemulti?fsyms=\(cryproCurrency)&tsyms=\(fiatCurrency)")
        
        let task = session.dataTask(with: url!) { data, response, err in
            if let error = err {
                NSLog("cryptocompare api error: \(error)")
            }
            
            // Check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let exchangeRate = self.exchangeRateFromJSONData(data!, from: cryproCurrency, to: fiatCurrency) {
                        success(exchangeRate)
                    }
                default:
                    NSLog(HTTPResponse.init(statusCode: httpResponse.statusCode).description)
                }
            }
        }
        task.resume()
    }
    
    func exchangeRateFromJSONData(_ data: Data, from cryproCurrency: String, to fiatCurrency: String) -> Double? {
        typealias JSONDict = [String: Any]
        let json: JSONDict
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        guard let currency = json[cryproCurrency] as? JSONDict else {
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
        
        return "cryptocompare API returned response with status code: \(statusCode) \(errorDescription) \(HTTPURLResponse.localizedString(forStatusCode: statusCode)) "
    }
    
}
