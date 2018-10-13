//
//  AlamofireExtensions.swift
//  Coin Menu Bar
//
//  Created by Horváth Balázs on 2018. 05. 05..
//  Copyright © 2018. Horváth Balázs. All rights reserved.
//

import Alamofire

public extension DataResponse {
    func toJson() -> NSDictionary {
        guard let responseJson = self.result.value as? NSDictionary else {
            fatalError("Unable to parse response to json!")
        }

        return responseJson
    }
}
