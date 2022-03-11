//
//  DetailNameTableViewCell.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 4.03.2022.
//

import UIKit

class DetailNameTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var nameTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
