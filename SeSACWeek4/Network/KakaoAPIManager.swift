//
//  KakaoAPIManager.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/11.
//

import Foundation
import SwiftyJSON
import Alamofire

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() {}
    
    let headers: HTTPHeaders = ["Authorization": APIKey.kakaoAPI]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (VideoList) -> Void) {
        
        let encodedText = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = type.requestURL + encodedText
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: VideoList.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func callRequestJSON(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> Void ) {
        
        let encodedText = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = type.requestURL + encodedText
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)
            case .failure(let error):
                print(error)
            }
        }
    }
}
