//
//  CustomCollectionViewTableViewCell.swift
//  Weather
//
//  Created by jh on 2021/04/06.
//

import UIKit

class CustomCollectionViewTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.collectionView!.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
