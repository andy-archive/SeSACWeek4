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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalTextView.text = "입력"
        translatedTextView.text = ""
        translatedTextView.isEditable = false
    }
    
    @IBAction func translateButtonClicked(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : "\(APIKey.naverClientID)",
            "X-Naver-Client-Secret" : "\(APIKey.naverClientSecret)",
        ]
        let parameters: Parameters = [
            "source": "ko",
            "target": "en",
            "text": originalTextView.text ?? "",
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
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
