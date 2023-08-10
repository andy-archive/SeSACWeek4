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
    let placeholderText = "번역하고 싶은 문장을 입력하세요"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadView()
    }
    
    @IBAction func translateButtonClicked(_ sender: UIButton) {
        getPapagoLanguageCode(query: originalTextView.text)
        getPapagoTranslationRequest(source: self.langCode)
        title = "\(langCode) → en"
    }
    
    func uploadView() {
        title = "\(langCode) → en"
        
        originalTextView.delegate = self
        originalTextView.text = placeholderText
        originalTextView.backgroundColor = .systemGreen
        
        translatedTextView.text = ""
        translatedTextView.backgroundColor = .systemGreen
        translatedTextView.isEditable = false
        
        translateButton.setTitle("번역하기", for: .normal)
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
                let data = json["message"]["result"]["translatedText"].stringValue
                
                self.translatedTextView.text = data
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: originalTextView - UITextFieldDelegate

extension TranslationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText  {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}
