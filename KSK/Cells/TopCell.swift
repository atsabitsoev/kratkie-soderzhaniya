//
//  TopCell.swift
//  KSK
//
//  Created by Ацамаз on 27/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit

class TopCell: UITableViewCell {
    
    @IBOutlet weak var imBook: UIImageView!
    @IBOutlet weak var labBookName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
