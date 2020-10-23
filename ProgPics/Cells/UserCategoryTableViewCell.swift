//
//  UserCategoryTableViewCell.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-09-18.
//

import Foundation
import UIKit

class UserCategoryTableViewCell: UITableViewCell {

    var title:String?
    var date:String?
    var ID:String?
    var thumbnailID:String?
    @IBOutlet weak var titleTextbox: UILabel!
    @IBOutlet weak var dateTextbox: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
