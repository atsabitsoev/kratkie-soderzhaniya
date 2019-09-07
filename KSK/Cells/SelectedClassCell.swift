//
//  SelectedClassCell.swift
//  KSK
//
//  Created by Ацамаз on 19/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit

class SelectedClassCell: UITableViewCell {

    
    
    @IBOutlet weak var imBook: UIImageView!
    @IBOutlet weak var labBookName: UILabel!
    @IBOutlet weak var labBookDescription: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
