//
//  KakaoAPIManager.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/11.
//

import Foundation
import SwiftyJSON
import Alamofire

final class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() {}
    
    private let headers = [
        "Authorization": APIKey.kakaoAPI
    ]
    
    private let headersAF: HTTPHeaders = [
        "Authorization": APIKey.kakaoAPI
    ]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (VideoList?) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    completionHandler(nil)
                    return
                }
                guard let data = data else {
                    completionHandler(nil)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(VideoList.self, from: data)
                    completionHandler(result)
                } catch {
                    print(error)
                    completionHandler(nil)
                }
            }
        }.resume()
    }
//        AF.request(url, method: .get, headers: headers)
//            .validate(statusCode: 200...500)
//            .responseDecodable(of: VideoList.self) { response in
//                switch response.result {
//                case .success(let value):
//                    completionHandler(value)
//                case .failure(let error):
//                    print(error)
//                }
//            }
    
    func callRequestJSON(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> Void ) {
        
        let encodedText = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = type.requestURL + encodedText
        
        AF.request(url, method: .get, headers: headersAF)
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
