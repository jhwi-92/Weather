//
//  CustomThreeHoursCollectionViewCell.swift
//  Weather
//
//  Created by jh on 2021/04/07.
//

import UIKit

class CustomThreeHoursCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayText: UILabel!
    
    @IBOutlet weak var hoursText: UILabel!
    @IBOutlet weak var temperatureText: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var apparelImage: UIImageView!
    
    
    
    func modifyCell(townItem: TownItem, index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.dayText.text = townItem.T3H[index].fcstDateMon+"/"+townItem.T3H[index].fcstDateDay
            self?.hoursText.text = townItem.T3H[index].fcstTimeSubStr
            self?.temperatureText.text = townItem.T3H[index].fcstValue
            self?.commentText.text = townItem.SKY[index].skyState
            self?.apparelImage.image = UIImage(named: "backgroundIMG")

            self?.setNeedsLayout()
        }
    }
    
}
