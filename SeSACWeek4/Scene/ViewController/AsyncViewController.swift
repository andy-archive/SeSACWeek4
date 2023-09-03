//
//  AsyncViewController.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/11.
//

import UIKit

final class AsyncViewController: UIViewController {

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var middleImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async { [self] in
            configureView()
        }
    }
    
    private func configureView() {
        topImageView.backgroundColor = .black
        topImageView.layer.cornerRadius = topImageView.frame.width / 2
    }
    
    // sync(기다리기) async(안 기다리기) serial(메인 스레드 몰빵) concurrent(멀티 스레드 N빵)
    // UI Freezing - 오래 걸리는 이벤트가 발생하는 동안 다른 것을 할 수 없다 (앱이 멈춘 상태)
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        let url = "https://api.nasa.gov/assets/img/general/apod.jpg"
        guard let url = URL(string: url) else { return }
        DispatchQueue.global().async { // 멀티 스레드에서 비동기로 url 작업 시키기
            let data = try! Data(contentsOf: url)
            DispatchQueue.main.async { // 메인 스레드에서 비동기로 이미지에 대한 데이터 받아 오기
                self.topImageView.image = UIImage(data: data)
            }
        }
    }
}
