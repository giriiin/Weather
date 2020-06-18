//
//  WeatherModel.swift
//  KakaoWeather
//
//  Created by 구자혁 on 14/06/2020.
//  Copyright © 2020 구자혁. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let weatherLoad = Notification.Name("WeatherLoad")
}

class WeatherModel: NSObject {

    static let shared = WeatherModel()
    
    var address: String?
    
    var current: WeatherCurrent?

    var hourly: Array<WeatherHourly> = Array<WeatherHourly>()

    var daily: Array<WeatherDaily> = Array<WeatherDaily>()

    private override init() {}
    
    func load(_ latitude: Float, _ longitude: Float, completion: @escaping (Bool) -> ()) {
        
        let key = "377ef47ed3defeba250005b813b6a53f"

        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(String(latitude))&lon=\(String(longitude))&exclude=minutely&units=metric&appid=\(key)"

        KakaoWeatherNetwork.get(url) { (response, success) in

            if success {
                //현재 날씨
                if let current = response["current"] as? [String: Any] {

                    WeatherModel.shared.current = WeatherCurrent(current)
                    
                }
                //시간별 일기 예보
                if let hourly = response["hourly"] as? Array<[String: Any]> {
                    
                    WeatherModel.shared.hourly.removeAll()
                    
                    for unit in hourly {
                        
                        WeatherModel.shared.hourly.append(WeatherHourly(unit))
                        
                    }
                    
                }
                //매일 일기 예보
                if let daily = response["daily"] as? Array<[String: Any]> {

                    WeatherModel.shared.daily.removeAll()
                    
                    for unit in daily {
                        
                        WeatherModel.shared.daily.append(WeatherDaily(unit))
                        
                    }

                }
                
                NotificationCenter.default.post(name: .weatherLoad, object: nil)
                
                completion(true)

            }
            else {
                
                completion(false)
                
            }

        }

    }
    
}

class WeatherCurrent: NSObject {

    var 현재날짜: Date?
    var 현재시간: String? //dt
    var 일출시간: String? //sunrise
    var 일몰시간: String? //sunset
    var 온도: String? //temp
    var 체감온도: String? //feels_like
    var 기압: String? //pressure
    var 습도: String? //humidity
    var 흐림율: String? //clouds
    var 자외선: String? //uvi
    var 풍속: String? //wind_speed
    var 풍향도: String? //wind_deg
    var 강수량: String? //rain
    var 적설량: String? //snow
    var 날씨아이콘: String? //weather.icon
    var 날씨: String? //weather.main
 
    init(_ response: [String: Any]) {
 
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "a h:mm"
        
        if let data = response["dt"] as? NSNumber {
            let date = Date(timeIntervalSince1970: TimeInterval(truncating: data))
            self.현재날짜 = date
            let dateString = dateFormatter.string(from: date)
            self.현재시간 = dateString
        }
        if let data = response["sunrise"] as? NSNumber {
            let date = Date(timeIntervalSince1970: TimeInterval(truncating: data))
            let dateString = dateFormatter.string(from: date)
            self.일출시간 = dateString
        }
        if let data = response["sunset"] as? NSNumber {
            let date = Date(timeIntervalSince1970: TimeInterval(truncating: data))
            let dateString = dateFormatter.string(from: date)
            self.일몰시간 = dateString
        }
        if let data = response["temp"] as? NSNumber {
            self.온도 = String(format: "%.0f",  round(data.doubleValue))
        }
        if let data = response["feels_like"] as? NSNumber {
            self.체감온도 = String(format: "%.0f",  round(data.doubleValue))
        }
        if let data = response["pressure"] as? NSNumber {
            self.기압 = data.stringValue
        }
        if let data = response["humidity"] as? NSNumber {
            self.습도 = data.stringValue
        }
        if let data = response["clouds"] as? NSNumber {
            self.흐림율 = data.stringValue
        }
        if let data = response["uvi"] as? NSNumber {
            self.자외선 = data.stringValue
        }
        if let data = response["wind_speed"] as? NSNumber {
            self.풍속 = data.stringValue
        }
        if let data = response["wind_deg"] as? NSNumber {
            self.풍향도 = data.stringValue
        }
        if let dataDictionary = response["rain"] as? [String: Any],
            let data = dataDictionary["1h"] as? NSNumber {
            self.강수량 = data.stringValue
        }
        if let dataDictionary = response["snow"] as? [String: Any],
        let data = dataDictionary["1h"] as? NSNumber {
            self.적설량 = data.stringValue
        }
        if let dataArray = response["weather"] as? Array<[String: Any]>, !dataArray.isEmpty{
            let dataDictionary = dataArray.last!
            if let data = dataDictionary["icon"] as? String {
                self.날씨아이콘 = data
                
                switch data {
                case "01d","01n":
                    self.날씨 = "맑음"
                case "02d","02n":
                    self.날씨 = "구름적음"
                case "03d","03n":
                    self.날씨 = "구름"
                case "04d","04n":
                    self.날씨 = "구름많음"
                case "09d","09n":
                    self.날씨 = "이슬비"
                case "10d","10n":
                    self.날씨 = "비"
                case "11d","11n":
                    self.날씨 = "번개"
                case "13d","13n":
                    self.날씨 = "눈"
                case "50d","50n":
                    self.날씨 = "안개"
                default:
                    self.날씨 = "알수없음"
                }
            }
        }
    }
}

class WeatherHourly: NSObject {

    var 현재날짜: Date?
    var 현재시간: String? //dt
    var 온도: String? //temp
    var 체감온도: String? //feels_like
    var 기압: String? //pressure
    var 습도: String? //humidity
    var 흐림율: String? //clouds
    var 풍속: String? //wind_speed
    var 풍향도: String? //wind_deg
    var 강수량: String? //rain
    var 적설량: String? //snow
    var 날씨아이콘: String? //weather.icon
    var 날씨: String? //weather.main
    
    init(_ response: [String: Any]) {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "a h시"
        
        if let data = response["dt"] as? NSNumber {
            let date = Date(timeIntervalSince1970: TimeInterval(truncating: data))
            self.현재날짜 = date
            let dateString = dateFormatter.string(from: date)
            self.현재시간 = dateString
        }
        if let data = response["temp"] as? NSNumber {
            self.온도 = String(format: "%.0f",  round(data.doubleValue))
        }
        if let data = response["feels_like"] as? NSNumber {
            self.체감온도 = String(format: "%.0f",  round(data.doubleValue))
        }
        if let data = response["pressure"] as? NSNumber {
            self.기압 = data.stringValue
        }
        if let data = response["humidity"] as? NSNumber {
            self.습도 = data.stringValue
        }
        if let data = response["clouds"] as? NSNumber {
            self.흐림율 = data.stringValue
        }
        if let data = response["wind_speed"] as? NSNumber {
            self.풍속 = data.stringValue
        }
        if let data = response["wind_deg"] as? NSNumber {
            self.풍향도 = data.stringValue
        }
        if let dataDictionary = response["rain"] as? [String: Any],
            let data = dataDictionary["1h"] as? NSNumber {
            self.강수량 = data.stringValue
        }
        if let dataDictionary = response["snow"] as? [String: Any],
        let data = dataDictionary["1h"] as? NSNumber {
            self.적설량 = data.stringValue
        }
        if let dataArray = response["weather"] as? Array<[String: Any]>, !dataArray.isEmpty{
            let dataDictionary = dataArray.last!
            if let data = dataDictionary["icon"] as? String {
                self.날씨아이콘 = data
                
                switch data {
                case "01d","01n":
                    self.날씨 = "맑음"
                case "02d","02n":
                    self.날씨 = "구름적음"
                case "03d","03n":
                    self.날씨 = "구름"
                case "04d","04n":
                    self.날씨 = "구름많음"
                case "09d","09n":
                    self.날씨 = "이슬비"
                case "10d","10n":
                    self.날씨 = "비"
                case "11d","11n":
                    self.날씨 = "번개"
                case "13d","13n":
                    self.날씨 = "눈"
                case "50d","50n":
                    self.날씨 = "안개"
                default:
                    self.날씨 = "알수없음"
                }
            }
        }
    }
}

class WeatherDaily: NSObject {

    var 현재날짜: Date?
    var 요일: String?
    var 현재시간: String? //dt
    var 일출시간: String? //sunrise
    var 일몰시간: String? //sunset
    var 아침온도: String? //temp.mron
    var 낮온도: String? //temp.day
    var 저녁온도: String? //temp.eve
    var 밤온도: String? //temp.night
    var 최저온도: String? //temp.min
    var 최고온도: String? //temp.max
    var 아침체감온도: String? //feels_like.morn
    var 낮체감온도: String? //feels_like.day
    var 저녁체감온도: String? //feels_like.eve
    var 밤체감온도: String? //feels_like.night
    var 기압: String? //pressure
    var 습도: String? //humidity
    var 풍속: String? //wind_speed
    var 풍향도: String? //wind_deg
    var 흐림율: String? //clouds
    var 자외선: String? //uvi
    var 강수량: String? //rain
    var 적설량: String? //snow
    var 날씨아이콘: String? //weather.icon
    var 날씨: String? //weather.main
    
    init(_ response: [String: Any]) {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "a h:mm"
        
        if let data = response["dt"] as? NSNumber {
            let date = Date(timeIntervalSince1970: TimeInterval(truncating: data))
            self.현재날짜 = date
            let calendar = Calendar(identifier: .gregorian)
            let day = calendar.dateComponents([.weekday], from: date).weekday
            switch day {
            case 1:
                self.요일 = "일요일"
            case 2:
                self.요일 = "월요일"
            case 3:
                self.요일 = "화요일"
            case 4:
                self.요일 = "수요일"
            case 5:
                self.요일 = "목요일"
            case 6:
                self.요일 = "금요일"
            case 7:
                self.요일 = "토요일"
            default:
                self.요일 = ""
            }
            let dateString = dateFormatter.string(from: date)
            self.현재시간 = dateString
        }
        if let data = response["sunrise"] as? NSNumber {
            let date = Date(timeIntervalSince1970: TimeInterval(truncating: data))
            let dateString = dateFormatter.string(from: date)
            self.일출시간 = dateString
        }
        if let data = response["sunset"] as? NSNumber {
            let date = Date(timeIntervalSince1970: TimeInterval(truncating: data))
            let dateString = dateFormatter.string(from: date)
            self.일몰시간 = dateString
        }
        if let dataDictionary = response["temp"] as? [String: Any] {
            if let data = dataDictionary["morn"] as? NSNumber {
                self.아침온도 = String(format: "%.0f",  round(data.doubleValue))
            }
            if let data = dataDictionary["day"] as? NSNumber {
                self.낮온도 = String(format: "%.0f",  round(data.doubleValue))
            }
            if let data = dataDictionary["eve"] as? NSNumber {
                self.저녁온도 = String(format: "%.0f",  round(data.doubleValue))
            }
            if let data = dataDictionary["night"] as? NSNumber {
                self.밤온도 = String(format: "%.0f",  round(data.doubleValue))
            }
            if let data = dataDictionary["min"] as? NSNumber {
                self.최저온도 = String(format: "%.0f",  round(data.doubleValue))
            }
            if let data = dataDictionary["max"] as? NSNumber {
                self.최고온도 = String(format: "%.0f",  round(data.doubleValue))
            }
        }
        if let dataDictionary = response["feels_like"] as? [String: Any] {
            if let data = dataDictionary["morn"] as? NSNumber {
                self.아침체감온도 = String(format: "%.0f",  round(data.doubleValue))
            }
            if let data = dataDictionary["day"] as? NSNumber {
                self.낮체감온도 = String(format: "%.0f",  round(data.doubleValue))
            }
            if let data = dataDictionary["eve"] as? NSNumber {
                self.저녁체감온도 = String(format: "%.0f",  round(data.doubleValue))
            }
            if let data = dataDictionary["night"] as? NSNumber {
                self.밤체감온도 = String(format: "%.0f",  round(data.doubleValue))
            }
        }
        if let data = response["pressure"] as? NSNumber {
            self.기압 = data.stringValue
        }
        if let data = response["humidity"] as? NSNumber {
            self.습도 = data.stringValue
        }
        if let data = response["wind_speed"] as? NSNumber {
            self.풍속 = data.stringValue
        }
        if let data = response["wind_deg"] as? NSNumber {
            self.풍향도 = data.stringValue
        }
        if let data = response["clouds"] as? NSNumber {
            self.흐림율 = data.stringValue
        }
        if let data = response["uvi"] as? NSNumber {
            self.자외선 = data.stringValue
        }
        if let dataDictionary = response["rain"] as? [String: Any],
            let data = dataDictionary["1h"] as? NSNumber {
            self.강수량 = data.stringValue
        }
        if let dataDictionary = response["snow"] as? [String: Any],
        let data = dataDictionary["1h"] as? NSNumber {
            self.적설량 = data.stringValue
        }
        if let dataArray = response["weather"] as? Array<[String: Any]>, !dataArray.isEmpty{
            let dataDictionary = dataArray.last!
            if let data = dataDictionary["icon"] as? String {
                self.날씨아이콘 = data
                
                switch data {
                case "01d","01n":
                    self.날씨 = "맑음"
                case "02d","02n":
                    self.날씨 = "구름적음"
                case "03d","03n":
                    self.날씨 = "구름"
                case "04d","04n":
                    self.날씨 = "구름많음"
                case "09d","09n":
                    self.날씨 = "이슬비"
                case "10d","10n":
                    self.날씨 = "비"
                case "11d","11n":
                    self.날씨 = "번개"
                case "13d","13n":
                    self.날씨 = "눈"
                case "50d","50n":
                    self.날씨 = "안개"
                default:
                    self.날씨 = "알수없음"
                }
            }
        }
    }
}
