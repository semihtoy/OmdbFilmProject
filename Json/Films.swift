//
//  Films.swift
//  Json
//
//  Created by Xcode on 23.10.2019.
//  Copyright © 2019 Xcode. All rights reserved.
//

import UIKit

class Films: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var tiTle: UILabel!
    @IBOutlet weak var Yearr: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
