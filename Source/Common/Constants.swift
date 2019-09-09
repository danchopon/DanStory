//
//  Constants.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/9/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Network {
        static let unsplashBaseUrl = "https://api.unsplash.com"
        
        /*
         
         To access Secrets.UNSPLASH_API_ACCESS_KEY -> Create Secrets.swift file and type inside code below:
                struct Secrets {
                    static let UNSPLASH_API_ACCESS_KEY = "$YOUR_UNSPLASH_ACCESS_KEY"
                }
         
        */
        
        static let unsplashAuthorizationClientId = "Client-ID \(Secrets.UNSPLASH_API_ACCESS_KEY)"
    }
}
