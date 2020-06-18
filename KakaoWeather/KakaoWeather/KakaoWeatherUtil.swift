//
//  KakaoWeatherUtil.swift
//  KakaoWeather
//
//  Created by 구자혁 on 16/06/2020.
//  Copyright © 2020 구자혁. All rights reserved.
//

import UIKit
import MapKit

class KakaoWeatherUtil: NSObject {

    static func setLocation(_ latitude: Float, _ longitude: Float) {
        
        UserDefaults.standard.set(latitude, forKey: "CurrentLatitude")
        UserDefaults.standard.set(longitude, forKey: "CurrentLongitude")
        
    }
    
    static func getLocation() -> (Float, Float) {
        
        let latitude = UserDefaults.standard.float(forKey: "CurrentLatitude")
        let longitude = UserDefaults.standard.float(forKey: "CurrentLongitude")
        
        if latitude != 0, longitude != 0 {
            
            return (latitude,longitude)
            
        }
        else {
            //default location
            return (37.3976653, 127.104994)
            
        }
        
    }
    
    static func getAddress(_ latitude: Float, _ longitude: Float, completion: @escaping (String, Bool) -> ()) {
        
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ko-kr")) { (placemarks, error) in
            
            if error == nil, !placemarks!.isEmpty, let placemark = placemarks?.first, let locality = placemark.locality {
                
                completion(locality, true)
                
            }
            else {
                
                completion("알수없음", false)
                
            }
            
        }

    }
    
    static func getLocation(_ address: String, completion: @escaping (CLLocation, Bool) -> ()) {
        
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            
            if error == nil, !placemarks!.isEmpty, let placemark = placemarks?.first, let location = placemark.location {
                
                completion(location, true)
                
            }
            else {
                
                completion(CLLocation(), false)
                
            }
            
        }
        
    }
    
}
