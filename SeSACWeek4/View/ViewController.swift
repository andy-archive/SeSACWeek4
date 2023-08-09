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

class ViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var movieList = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.rowHeight = 60
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        callRequest()
    }
    
    func callRequest() {
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=20120101"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
//                print(name1, name2, name3, "====================", separator: "\n")
                
                // 1. 일일이 넣기 with using append(contentsOf: )
//                self.movieList.append(contentsOf: [name1, name2, name3])
                
                // 2. for 문과 arrayValue를 이용해서 모든 정보 담기
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = item["movieNm"].stringValue
                    let openDt = item["openDt"].stringValue
                    
                    let data = Movie(title: movieNm, releasedDate: openDt)
                    
                    self.movieList.append(data)
                }
                
                self.movieTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") else { return UITableViewCell() }
        cell.textLabel?.text = movieList[indexPath.row].title
        cell.detailTextLabel?.text = "FOR TEST"
        
        return cell
    }
}
