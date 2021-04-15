//
//  UIViewControllerExtension.swift
//  Weather
//
//  Created by jh on 2021/04/09.
//

import UIKit

extension UIViewController {
    //alert
    func presentAlert(_ title: String, message: String, completion: (()-> ())?) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let confirm = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(confirm)
        
            self?.present(alert, animated: true, completion: {
                completion?()
            })
        }
    }
    

    
    
}
