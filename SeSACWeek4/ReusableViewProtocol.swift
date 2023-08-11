//
//  ReusableViewProtocol.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/11.
//

import UIKit

// 단, 여기서는 필요없다, 다만 구조를 잡아 볼 필요가 있다
// 코드를 처음 보는 사람이 이해하기 쉽도록 적기 위함
protocol ReusableViewProtocol { // 주로 명시적으로 "Protocol"이라는 명칭을 뒤에 쓴다
    static var identifier: String { get }
    
}

extension UIViewController: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
