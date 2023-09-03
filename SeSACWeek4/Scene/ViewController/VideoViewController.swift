//
//  VideoViewController.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

final class VideoViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet private weak var videoTableView: UITableView! {
        didSet {
            videoTableView.delegate = self
            videoTableView.dataSource = self
            videoTableView.prefetchDataSource = self
            videoTableView.rowHeight = 140
        }
    }
    
    var videoList = [Video]() {
        didSet {
            videoTableView.reloadData()
        }
    }
    private var page = 1
    private var isEnd = false // 현재 페이지가 마지막 페이지인지 점검하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func callRequest(query: String, page: Int) {
        KakaoAPIManager.shared.callRequest(type: .video, query: query) { json in
            guard let json = json else { return }
            guard let documents = json.documents else { return }
//            guard let meta = json.meta else { return }
                    
            self.videoList.append(contentsOf: documents)
        }
    }
}

//MARK: UISearchBarDelegate

extension VideoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        videoList.removeAll()
        
        guard let query = searchBar.text else { return }
        callRequest(query: query, page: page)
    }
}

// UITableViewDataSourcePrefetching
// iOS 10 이상 사용이 가능한 프로토콜
// cellForRowAt 메서드 호출 전에 미리 호출이 된다
extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier) as? VideoTableViewCell else { return UITableViewCell() }
        
        let row = videoList[indexPath.row]
        cell.titleLabel.text = row.title
        cell.contentLabel.text = row.contents
        
        guard let url = URL(string: row.thumbnail) else { return UITableViewCell() }
        cell.thumbnailImageView.kf.setImage(with: url)
        
        return cell
    }
    
    // 셀이 화면에 보이기 직전에 리소스를 미리 다운 받음
    // videoList의 개수와 indexPath.row의 위치를 비교해 마지막 스크롤 시점을 확인한다 => 네트워크 요청을 시도
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if videoList.count - 1 == indexPath.row && page < 15 && isEnd == false {
                page += 1
                callRequest(query: searchBar.text!, page: page)
            }
        }
    }
    
    // 취소 - 직접 취소하는 기능을 구현해야 함
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("======= CANCEL: \(indexPaths)")
    }
}
