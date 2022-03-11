//
//  DetailDescriptionTableViewCell.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 4.03.2022.
//

import UIKit

class DetailDescriptionTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var descriptionTextLabel: UITextView!{
        didSet{
            descriptionTextLabel.isEditable = false
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
