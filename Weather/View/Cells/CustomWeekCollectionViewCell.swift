//
//  CustomWeekCollectionViewCell.swift
//  Weather
//
//  Created by jh on 2021/04/08.
//

import UIKit

class CustomWeekCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var maxText: UILabel!
    @IBOutlet weak var minText: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var apparelImage: UIImageView!
    
    
    func modifyCell(townItem: TownItem, index: Int) {
        DispatchQueue.main.async { [weak self] in
            let mon: String = townItem.TMN[index].fcstDateMon
            let day: String = townItem.TMN[index].fcstDateDay
            let year: String = townItem.TMN[index].fcstDateYear
            
            self?.dayText.text = Date().weekday(year: Int(year)!, month: Int(mon)!, day: Int(day)!)
            //cell.apparalImage
            self?.maxText.text = "최고"
            self?.minText.text = "최저"
            self?.maxTemperature.text = townItem.TMX[index].fcstValue
            self?.minTemperature.text = townItem.TMN[index].fcstValue
            self?.apparelImage.image = UIImage(named: "backgroundIMG")
            self?.setNeedsLayout()
        }
    }
    
}
