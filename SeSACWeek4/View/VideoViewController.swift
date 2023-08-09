//
//  VideoViewController.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire

struct Video {
    let author: String
    let date: String
    let playTime: Int
    let thumbnail: String
    let title: String
    let url: String
}

class VideoViewController: UIViewController {

    var videoList = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callRequest()
    }
    
    func callRequest() {
        let text = "아이유".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)"
        let header: HTTPHeaders = ["Authorization": "2dkj23lkj3223j3k"]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                print(response.response?.statusCode) // 상태코드에 대한 것을 출력
                let statusCode = response.response?.statusCode ?? 500 // 옵셔널 체이닝
                
                if statusCode == 200 {
                    for item in json["documents"].arrayValue {
                        let author = item["author"].stringValue
                        let date = item["datetime"].stringValue
                        let playTime = item["play_time"].intValue
                        let thumbnail = item["thumbnail"].stringValue
                        let title = item["title"].stringValue
                        let url = item["url"].stringValue
                        
                        let data = Video(author: author, date: date, playTime: playTime, thumbnail: thumbnail, title: title, url: url)
                        
                        self.videoList.append(data)
                    }
                } else {
                    print("ERROR.")
                }
                

                
                print(self.videoList, "=====================")
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
