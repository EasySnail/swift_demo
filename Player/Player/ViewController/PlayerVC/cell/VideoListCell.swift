//
//  VideoListCell.swift
//  Player
//
//  Created by Easy on 2017/12/12.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit

class VideoListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.textLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    func updateModel(_ model:VideoModel) {
        self.textLabel?.text = model.name
        let image = model.type ?? "other"
        self.imageView?.image = UIImage(named:"video" + image.lowercased())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
