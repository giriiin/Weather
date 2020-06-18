//
//  WeatherViewController.swift
//  KakaoWeather
//
//  Created by 구자혁 on 13/06/2020.
//  Copyright © 2020 구자혁. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var weatherImageViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var weatherStateLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var tempLabelTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var todayLabelLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tablewView: UITableView!
    
//    var today: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.layer.cornerRadius = 30
        
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        if UIScreen.main.bounds.width < 375 {
            
            self.weatherImageViewLeadingConstraint.constant = 15
            
            self.tempLabelTrailingConstraint.constant = 15
            
        }
        else {
            
            self.weatherImageViewLeadingConstraint.constant = 30
            
            self.tempLabelTrailingConstraint.constant = 30
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWeatherUI), name: .weatherLoad, object: nil)
        
    }
    
    @objc func updateWeatherUI() {
        
        if let current = WeatherModel.shared.current {
            
            let hourly = WeatherModel.shared.hourly
            
            let daily = WeatherModel.shared.daily
            
            let location = KakaoWeatherUtil.getLocation()
            KakaoWeatherUtil.getAddress(location.0, location.1) { (address, success) in
                
                DispatchQueue.main.async {
                    
                    WeatherModel.shared.address = address
                    
                    self.cityNameLabel.text = address
                    
                    if let 온도 = current.온도 {
                        self.tempLabel.text = 온도 + "°"
                    }
                    if let 날씨 = current.날씨 {
                        self.weatherStateLabel.text = 날씨
                    }
                    if let 날씨아이콘 = current.날씨아이콘 {
                        self.weatherImageView.image = UIImage(named: 날씨아이콘)
                    }
//                    if let 현재날짜 = current.현재날짜 {
//                        self.today = 현재날짜
//                    }
                    
                    if !hourly.isEmpty {
                        
//                        self.todayLabel.text = "오늘"
                        
                        self.collectionView.contentOffset = CGPoint.zero
                        
                        self.collectionView.reloadData()
                        
                        self.collectionView.contentOffset = CGPoint.zero
                        
                    }
                    
                    if !daily.isEmpty {
                        
                        self.tablewView.reloadData()
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension UIView {
    
    fileprivate func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return WeatherModel.shared.hourly.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let hourly = WeatherModel.shared.hourly[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell {
            
            if let 현재시간 = hourly.현재시간 {
                cell.timeLabel.text = 현재시간
            }
            if let 날씨아이콘 = hourly.날씨아이콘 {
                cell.weatherImageView.image = UIImage(named: 날씨아이콘)
            }
            if let 온도 = hourly.온도 {
                cell.tempLabel.text = 온도 + "°"
            }
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let index = Int(round(scrollView.contentOffset.x / 80)) + 2
//
//        if index > 0, index < WeatherModel.shared.hourly.count - 1, today != nil {
//
//            let hourly = WeatherModel.shared.hourly[index]
//
//            if hourly.현재날짜 != nil {
//
//                let day = Int(hourly.현재날짜!.timeIntervalSince(today!) / 86400)
//
//                if day == 0 {
//
//                    self.todayLabel.text = "오늘"
//
//                }
//                else if day == 1 {
//
//                    self.todayLabel.text = "내일"
//
//
//                }
//                else if day == 2 {
//
//                    self.todayLabel.text = "모레"
//
//                }
//
//            }
//
//        }
//
//    }
    
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return WeatherModel.shared.daily.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let daily = WeatherModel.shared.daily[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell {
        
            if let 요일 = daily.요일 {
                cell.timeLabel.text = 요일
            }
            if let 날씨아이콘 = daily.날씨아이콘 {
                cell.weatherImageView.image = UIImage(named: 날씨아이콘)
            }
            if let 최고온도 = daily.최고온도 {
                cell.maxTempLabel.text = 최고온도 + "°"
            }
            if let 최저온도 = daily.최저온도 {
                cell.minTempLabel.text = 최저온도 + "°"
            }
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
}
