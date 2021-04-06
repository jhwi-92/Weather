//
//  CustomTodayTableViewCell.swift
//  Weather
//
//  Created by jh on 2021/04/06.
//

import UIKit

class CustomTodayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var averageText: UILabel!
    @IBOutlet weak var temperatureSymbol: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var todayText: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
