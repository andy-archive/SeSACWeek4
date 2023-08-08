//
//  WeatherViewController.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callRequest()
        
        weatherLabel.numberOfLines = 0
        tempLabel.numberOfLines = 0
        humidityLabel.numberOfLines = 0
    }
    
    func callRequest() {
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(APIKey.latitude)&lon=\(APIKey.longitude)&appid=\(APIKey.weatherKey)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let temp = json["main"]["temp"].doubleValue - 273.15
                let humidity = json["main"]["humidity"].intValue
                
                let id = json["weather"][0]["id"].intValue
                
                switch id {
                case 800: self.weatherLabel.text = "매우 맑음"
                case 801...899: self.weatherLabel.text =  "구름이 낀 날씨에요"
                default: self.weatherLabel.text = "생략 :)"
                }
                
                self.tempLabel.text = "온도는 \(temp)도 입니다"
                self.humidityLabel.text = "습도는 \(humidity)%입니다"
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
