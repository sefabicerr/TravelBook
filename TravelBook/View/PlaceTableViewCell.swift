//
//  PlaceTableViewCell.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 2.03.2022.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var placeImageView: UIImageView!{
        didSet{
            placeImageView.layer.cornerRadius = placeImageView.bounds.width / 2
            placeImageView.contentMode = .scaleAspectFill
            placeImageView.clipsToBounds = true
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
