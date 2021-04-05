//
//  ViewController.swift
//  Weather
//
//  Created by jh on 2021/04/05.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
        self.setNavigationBar()
        
    }

    func setNavigationBar(){
            let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
        }


    //출처: https://tom7930.tistory.com/23 [Dr.kim의 나를 위한 블로그]
}



extension UIView {
func addBackground() {
    // screen width and height:
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height

    let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    imageViewBackground.image = UIImage(named: "backgroundIMG")

    // you can change the content mode:
    imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

    self.addSubview(imageViewBackground)
    self.sendSubviewToBack(imageViewBackground)
}}
