//
//  TranslationViewController.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/10.
//

import UIKit
import SwiftyJSON
import Alamofire

class TranslationViewController: UIViewController {

    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    
    var langCode = "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalTextView.text = "원하는 언어로 번역하고 싶은 문장을 입력하세요"
        translatedTextView.text = ""
        translatedTextView.isEditable = false
    }
    
    @IBAction func translateButtonClicked(_ sender: UIButton) {
//        print("BEFORE: ", self.langCode)
        getPapagoLanguageCode(query: originalTextView.text)
//        print("AFTER: ", self.langCode)
        getPapagoTranslationRequest(source: self.langCode)
    }
    
    func getPapagoLanguageCode(query: String) {
        let encodedText = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "https://openapi.naver.com/v1/papago/detectLangs?query=\(encodedText)"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "\(APIKey.naverClientID)",
            "X-Naver-Client-Secret": "\(APIKey.naverClientSecret)",
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
        ]
        
        AF.request(url,
                   method: .post,
                   headers: headers
        ).validate(statusCode: 200..<300
        ).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let statusCode = response.response?.statusCode ?? 500
                print("JSON: \(json)")
                print("STATUS CODE: \(statusCode)")
                
                if statusCode == 200 {
                    self.langCode = json["langCode"].stringValue
                } else {
                    print("REQUEST ERROR: \(statusCode)")
                }

            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPapagoTranslationRequest(source: String) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : "\(APIKey.naverClientID)",
            "X-Naver-Client-Secret" : "\(APIKey.naverClientSecret)",
        ]
        let parameters: Parameters = [
            "source": "\(source)",
            "target": "en",
            "text": originalTextView.text ?? "",
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            headers: header
        ).validate(
        ).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                self.translatedTextView.text = data
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
