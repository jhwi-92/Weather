//
//  CustomApparelCollectionViewCell.swift
//  Weather
//
//  Created by jh on 2021/04/06.
//

import UIKit

class CustomApparelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var apparelImage: UIImageView!
    @IBOutlet weak var apparelText: UILabel!
    
    
    func modifyCell(apparel: Apprel) {
        DispatchQueue.main.async { [weak self] in
            
            self?.apparelImage.image = UIImage(named: apparel.apprelImgStr)
            self?.apparelText.text = apparel.apparelName
            self?.setNeedsLayout()
        }
    }
}
