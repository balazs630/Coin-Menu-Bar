//
//  StringExtensions.swift
//  CoinMenuBar
//
//  Created by Horváth Balázs on 2017. 12. 13..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Foundation

public extension String {
    func filterNumbers() -> String {
        // Clear invalid input, e.x. letters
        let numberSet = "0123456789"
        return self.filter { numberSet.contains($0) }
    }
}
