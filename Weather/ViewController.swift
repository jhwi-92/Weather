//
//  ViewController.swift
//  Weather
//
//  Created by jh on 2021/04/05.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func plusButton(_ sender: Any) {
        print("plusButton")
    }
    
    @IBAction func menuButton(_ sender: Any) {
        print("menuButton")
    }
    @IBOutlet var tableView: UITableView!
    
    
    let testText:[String?] = ["트렌치코트","잠바","패딩","아아","어어"]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //self.view.collection
        
      
        self.setNavigationBar()
        self.view.addBackground()
        
    }

    //네비게이션 바 투명하도록
    func setNavigationBar(){
            let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }


}



extension UIView {
    
    //MARK: Background
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "backgroundIMG")

        // content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
    
}
//MARK: TableViewDelegate
extension ViewController: UITableViewDelegate {
    
}
//MARK: TableViewDataSource
extension ViewController: UITableViewDataSource {
    
    //섹션당 행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell: CustomTodayTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as? CustomTodayTableViewCell else {return CustomTodayTableViewCell()}
            cell.averageText.text = "평균"
            cell.todayText.text = "4월 6일 16시"
            cell.temperature.text = "20"
            cell.comment.text = "오늘은 흐린날이에요... 가디건 추천드려요"
            cell.temperatureSymbol.text = "oC"
            return cell
        } else if indexPath.row == 1 {
            
            guard let cell: CustomCollectionViewTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "inCollectionCell", for: indexPath) as? CustomCollectionViewTableViewCell else {return CustomCollectionViewTableViewCell()}
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 88, height: 88)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: CustomApparelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "apparelCell", for: indexPath) as? CustomApparelCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.contentView.backgroundColor = .clear
        cell.apparelImage.image = UIImage(named: "backgroundIMG")
        cell.apparelText.text = testText[indexPath.item]
        
        return  cell
    }
    
}
