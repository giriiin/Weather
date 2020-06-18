//
//  AppDelegate.swift
//  KakaoWeather
//
//  Created by 구자혁 on 13/06/2020.
//  Copyright © 2020 구자혁. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let location = KakaoWeatherUtil.getLocation()
        WeatherModel.shared.load(location.0,location.1, completion: {_ in })
        
        let time = 60
        Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: true) { (timer) in
            
            let location = KakaoWeatherUtil.getLocation()
            WeatherModel.shared.load(location.0,location.1, completion: {_ in })
            
        }
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        let location = KakaoWeatherUtil.getLocation()
        WeatherModel.shared.load(location.0,location.1, completion: {_ in })
        
    }

}

