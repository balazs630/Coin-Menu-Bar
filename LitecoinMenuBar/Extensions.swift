//
//  Extensions.swift
//  Litecoin Menu Bar
//
//  Created by Horváth Balázs on 2017. 12. 13..
//  Copyright © 2017. Horváth Balázs. All rights reserved.
//

import Foundation

public extension String {
    func filterNumbers(upto maxlength: Int, isDouble: Bool = false) -> String {
        // Clear invalid input, e.x. letters
        
        let numberSet = (isDouble == true) ? ".0123456789" : "0123456789"
        let filtered = String(self.filter { numberSet.contains($0) })
        
        // Doesn't allow numbers greater than maxlength digits
        if filtered.count > maxlength {
            return String(filtered.prefix(maxlength))
        } else {
            return filtered
        }
    }
    
}
