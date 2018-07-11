//
//  MyLocationViewController.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/4/28.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class MyLocationViewController: UIViewController,CLLocationManagerDelegate {
    var mainMapView: MKMapView!
    var location: UITextView!

    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //使用代码创建
        self.mainMapView = MKMapView(frame: CGRect(x:0, y: UIScreen.main.bounds.height/4, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*3/4))
        self.location = UITextView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/8, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*1/4))
        self.view.addSubview(self.mainMapView)
        self.view.addSubview(self.location)
        
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        ////发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        loadMap(location: currLocation)
        reverseGeocode(loction: currLocation)
        locationManager.stopUpdatingHeading()
    }
    func loadMap(location: CLLocation){
        self.mainMapView.mapType = MKMapType.standard
        
        let latDelta = 0.02
        let longDelta = 0.02
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let center:CLLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,
                                                                  span: currentLocationSpan)
        
        //设置显示区域
        self.mainMapView.setRegion(currentRegion, animated: true)
        
        //创建一个大头针对象
        let objectAnnotation = MKPointAnnotation()
        //设置大头针的显示位置
        objectAnnotation.coordinate = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude).coordinate
        //设置点击大头针之后显示的标题
        objectAnnotation.title = "我的位置"
        //设置点击大头针之后显示的描述

        //添加大头针
        self.mainMapView.addAnnotation(objectAnnotation)
    }
    
    //获取定位信息
    func reverseGeocode(loction: CLLocation){
        let geocoder = CLGeocoder()
        
        let currentLocation = CLLocation(latitude: loction.coordinate.latitude, longitude: loction.coordinate.longitude)
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in
            //强制转成简体中文
            let array = NSArray(object: "zh-hans")
            UserDefaults.standard.set(array, forKey: "AppleLanguages")
            //显示所有信息
            
            if let p = placemarks?[0]{
                print(p) //输出反编码信息
               // UserDefaults.standard.set(p, forKey: "location")
                var address = ""
                
                if let country = p.country {
                    address.append("国家：\(country)\n")
                }
                if let administrativeArea = p.administrativeArea {
                    address.append("省份：\(administrativeArea)\n")
                }
                if let subAdministrativeArea = p.subAdministrativeArea {
                    address.append("其他行政区域信息（自治区等）：\(subAdministrativeArea)\n")
                }
                if let locality = p.locality {
                    address.append("城市：\(locality)\n")
                }
                if let subLocality = p.subLocality {
                    address.append("区划：\(subLocality)\n")
                }
                if let thoroughfare = p.thoroughfare {
                    address.append("街道：\(thoroughfare)\n")
                }
                if let subThoroughfare = p.subThoroughfare {
                    address.append("门牌：\(subThoroughfare)\n")
                }
                if let name = p.name {
                    address.append("地名：\(name)\n")
                }
                if let isoCountryCode = p.isoCountryCode {
                    address.append("国家编码：\(isoCountryCode)\n")
                }
                if let postalCode = p.postalCode {
                    address.append("邮编：\(postalCode)\n")
                }
                if let areasOfInterest = p.areasOfInterest {
                    address.append("关联的或利益相关的地标：\(areasOfInterest)\n")
                }
                if let ocean = p.ocean {
                    address.append("海洋：\(ocean)\n")
                }
                if let inlandWater = p.inlandWater {
                    address.append("水源，湖泊：\(inlandWater)\n")
                }
                self.location.text = address
                
            } else {
                self.location.text = "无位置信息！"
            }
        })
    }
    
    
}


