//
//  RestaurantService.swift
//  Restaurants
//
//  Created by Alejocram on 10/09/16.
//  Copyright © 2016 EAFIT. All rights reserved.
//

import UIKit
import Alamofire

public typealias CompletionHandlerGET =  (success: Bool, response: [[String : AnyObject]]) ->()

let headers = ["Authorization":"Basic a2lkX3JKQjN2cS1uOjg0YTBjODhjODc3MTRmNjZiNmIzMDQyZmFkNDk4Yjcx",
    "Content-Type":"application/x-www-form-urlencoded"]

class RestaurantService: NSObject {
    let url = "https://baas.kinvey.com/appdata/kid_rJB3vq-n/restaurants"
    
    func getRestaurants(completion:CompletionHandlerGET){
        Alamofire.request(.GET, url, parameters: nil, headers: headers)
            .responseJSON(){response in
                
                switch response.result {
                case .Success(let JSON):
                    print("Llamado de GET \(JSON)")
                    completion(success: true, response: JSON as! [[String : AnyObject]])
                case .Failure(let error):
                    completion(success: false, response: [["error":error.localizedDescription]])
                }
        }
    }
}







    