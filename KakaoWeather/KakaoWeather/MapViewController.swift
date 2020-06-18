//
//  MapViewController.swift
//  KakaoWeather
//
//  Created by 구자혁 on 13/06/2020.
//  Copyright © 2020 구자혁. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    weak var weatherTableView: UITableView?
    
    var safeTopHeight: CGFloat!
    
    var safeBottomHeight:CGFloat!
    
    var beganHeight: CGFloat!
    
    var maxHeight: CGFloat!
    
    var minHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchView.layer.cornerRadius = 20
        self.searchView.clipsToBounds = true
        self.searchView.layer.masksToBounds = false
        self.searchView.layer.shadowColor = UIColor.black.cgColor
        self.searchView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.searchView.layer.shadowOpacity = 0.25
        self.searchView.layer.shadowRadius = 10
        
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: -3)
        self.containerView.layer.shadowOpacity = 0.25
        self.containerView.layer.shadowRadius = 20
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let bottom = appDelegate.window?.safeAreaInsets.bottom,
            let top = appDelegate.window?.safeAreaInsets.top  {
            self.safeTopHeight = top
            self.safeBottomHeight = bottom
        }
        
        self.minHeight = 220 + safeBottomHeight
        self.maxHeight = UIScreen.main.bounds.height - self.searchView.frame.height - safeTopHeight - 10
        
        self.maxHeight = 548 + safeBottomHeight
        self.containerViewHeightConstraint.constant = minHeight
        
        self.mapView.layoutMargins.top = 40
        self.mapView.layoutMargins.bottom = minHeight - safeBottomHeight
        
        if let childViewController = self.children.first as? WeatherViewController {
            
            self.weatherTableView = childViewController.tablewView
            
            self.weatherTableView?.alpha = 0
            
        }
        
        self.updateLocationUI()
        
    }
    
    func updateLocationUI() {
        
        let location = KakaoWeatherUtil.getLocation()
        
        let initialLocation = CLLocation(latitude: CLLocationDegrees(location.0), longitude: CLLocationDegrees(location.1))
        
        let coordinateRegion = MKCoordinateRegion( center: initialLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        self.mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    @IBAction func textFieldDidEndOnExit(_ sender: UITextField) {
        
        if let text = sender.text, !text.isEmpty {
            
            KakaoWeatherUtil.getLocation(text) { (location, success) in
                
                if success {
                    
                    KakaoWeatherUtil.setLocation(Float(location.coordinate.latitude), Float(location.coordinate.longitude))
                    
                    let location = KakaoWeatherUtil.getLocation()
                    WeatherModel.shared.load(location.0,location.1, completion: {_ in })
                    
                    self.updateLocationUI()
                    
                    
                }
                
            }
            
            sender.text = ""
            
        }
        
    }
    
    @IBAction func panGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.containerView)
        
        let changedY = translation.y
        
        if sender.state == .began {
            
            self.beganHeight = self.containerViewHeightConstraint.constant
            
        }
        else if sender.state == .changed {
            
            let height = self.beganHeight - changedY
            
            if height <= self.maxHeight && height >= self.minHeight {
                
                self.containerViewHeightConstraint.constant = height
                
            }
            
        }
        else if sender.state == .ended {
            
            if abs(self.containerViewHeightConstraint.constant - self.minHeight) > abs(self.containerViewHeightConstraint.constant - self.maxHeight) {
                
                self.containerViewHeightConstraint.constant = self.maxHeight
                
                UIView.animate(withDuration: 0.25) {
                    
                    self.weatherTableView?.alpha = 100
                    
                    self.view.layoutIfNeeded()
                    
                }
                
            }
            else {
                
                self.containerViewHeightConstraint.constant = self.minHeight
                
                UIView.animate(withDuration: 0.25) {
                    
                    self.weatherTableView?.alpha = 0
                        
                    self.view.layoutIfNeeded()
                    
                }
                
            }
            
        }
        
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        KakaoWeatherUtil.getAddress(Float(mapView.centerCoordinate.latitude), Float(mapView.centerCoordinate.longitude)) { (address, success) in
            
            if address != "알수없음", address != WeatherModel.shared.address {
                
                KakaoWeatherUtil.setLocation(Float(mapView.centerCoordinate.latitude), Float(mapView.centerCoordinate.longitude))
                
                let location = KakaoWeatherUtil.getLocation()
                WeatherModel.shared.load(location.0,location.1, completion: {_ in })
                
                self.updateLocationUI()
                
            }
            
        }
        
    }
    
}

