//
//  SliderCollectionViewCell.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 2.03.2022.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderImage: UIImageView!{
        didSet{
            sliderImage.contentMode = .scaleAspectFill
            sliderImage.clipsToBounds = true
            sliderImage.layer.cornerRadius = 50.0
        }
    }
    
}
