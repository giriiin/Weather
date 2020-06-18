//
//  KakaoWeatherNetwork.swift
//  KakaoWeather
//
//  Created by 구자혁 on 13/06/2020.
//  Copyright © 2020 구자혁. All rights reserved.
//

import UIKit

class KakaoWeatherNetwork: NSObject {

    static func get(_ url:String, completion: @escaping ([String: Any], Bool) -> ()) {
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                
                if let jsonDictionary = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String: Any] {
                    
                    completion(jsonDictionary, true)
                    
                }
                else {
                    
                    completion([:], false)
                    
                }

            }
            else {
                
                completion([:], false)
                
            }
            
            
        }
        
        task.resume()
        
    }
    
    static func post() {
        
        
    }
    
}
