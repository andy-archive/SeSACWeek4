//
//  ViewController.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie {
    var title: String
    var releasedDate: String
}

// JSON이 필요한 원리 
//struct BoxOfficeResult: Decodable {
//    let result: BoxOfficeSecond
//}
//
//struct BoxOfficeSecond: Decodable {
//    let boxOfficeType: String
//    let dailyBoxOfficeList: [BoxOffice]
//    let showRange: String
//}
//
//struct BoxOffice: Decodable {
//    
//}

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var movieList = [Movie]()
    
    //Codable
    var result: BoxOffice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.rowHeight = 60
        movieTableView.delegate = self
        movieTableView.dataSource = self
        indicatorView.isHidden = true
    }
    
    func callRequest(date: String) {
       
        indicatorView.startAnimating()
        indicatorView.isHidden = false // 네트워크 통신 시 드러나기
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"
        
        // https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#chained-response-handlers
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: BoxOffice.self) { response in
//                print(response)
                print(response.value)
                self.result = response.value
                self.movieTableView.reloadData()
            }
            
//            .responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
                
//                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
//                print(name1, name2, name3, "====================", separator: "\n")
                
                // 1. 일일이 넣기 with using append(contentsOf: )
//                self.movieList.append(contentsOf: [name1, name2, name3])
                
                // 2. for 문과 arrayValue를 이용해서 모든 정보 담기
//                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
//                    let movieNm = item["movieNm"].stringValue
//                    let openDt = item["openDt"].stringValue
//
//                    let data = Movie(title: movieNm, releasedDate: openDt)
//
//                    self.movieList.append(data)
//                }
//
//                self.indicatorView.stopAnimating() // 이걸 해주지 않으면 계속 애니메이션이 뒤에서 돌아가고 있다
//                self.indicatorView.isHidden = true // 갱신 시 보여주기
//                self.movieTableView.reloadData()
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        callRequest(date: searchBar.text ?? "20230101")
    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//
//    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = result?.boxOfficeResult.dailyBoxOfficeList.count else { return 0 }
        return data //movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") else { return UITableViewCell() }
        guard let data = result?.boxOfficeResult.dailyBoxOfficeList else { return UITableViewCell() }
        
        cell.textLabel?.text = data[indexPath.row].movieNm
        cell.detailTextLabel?.text = "FOR TEST"
        
        return cell
    }
}
