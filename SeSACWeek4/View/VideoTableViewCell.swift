//
//  VideoTableViewCell.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/09.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    static let identifier = "VideoTableViewCell"

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0
        thumbnailImageView.contentMode = .scaleToFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
