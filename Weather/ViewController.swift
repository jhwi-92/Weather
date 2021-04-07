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
    
    var tableViewIndexPath = Int()
    let testText:[String?] = ["트렌치코트","잠바","패딩","아아","어어"]
    let testDayText:[String?] = ["04/07","04/08","04/08","04/08","04/08","04/08","04/08","04/08"]
    let testHoursText:[String?] = ["21시","00시","03시","06시","09시","12시","15시","18시"]
    let testTemText:[String?] = ["11C","9C","6C","4C","10C","15C","16C","14C"]
    let testCommentText:[String?] = ["맑아요","흐려요","흐려요","흐려요","흐려요","맑아요","맑아요","맑아요"]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //self.view.collection
        //self.tableView.rowHeight = 200
        
      
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
        return 3
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
            tableViewIndexPath = indexPath.row
            guard let cell: CustomCollectionViewTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "inCollectionCell", for: indexPath) as? CustomCollectionViewTableViewCell else {return CustomCollectionViewTableViewCell()}
            
            cell.collectionView?.delegate = self
            cell.collectionView?.dataSource = self
            //cell.collectionView?.backgroundColor = UIColor.init(red: 10, green: 10, blue: 10, alpha: 1)
            
            return cell
        } else if indexPath.row == 2 {
            tableViewIndexPath = indexPath.row
            guard let cell: CustomThreeHoursCollectionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "threeHoursCell", for: indexPath) as? CustomThreeHoursCollectionTableViewCell else {return CustomThreeHoursCollectionTableViewCell()}
            
            cell.collectionView?.delegate = self
            cell.collectionView?.dataSource = self
            //cell.collectionView?.backgroundColor = UIColor.init(red: 10, green: 10, blue: 10, alpha: 1)
            
            return cell
        }
        return UITableViewCell()
    }
}
//MARK: UICollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 88, height: 88)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //self.tableView.
        if tableViewIndexPath == 1 {
            return testText.count
        } else if tableViewIndexPath == 2 {
            return testHoursText.count
        } else {return 1}
        //return testText.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if tableViewIndexPath == 1 {
            guard let cell: CustomApparelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "apparelCell", for: indexPath) as? CustomApparelCollectionViewCell else {
                return UICollectionViewCell()
            }
           //cell.contentView.backgroundColor = .clear
            cell.apparelImage.image = UIImage(named: "backgroundIMG")
            cell.apparelText.text = testText[indexPath.item]
            
            return  cell
        } else if tableViewIndexPath == 2 {
            guard let cell: CustomThreeHoursCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "threeHoursCell", for: indexPath) as? CustomThreeHoursCollectionViewCell else {
                return CustomThreeHoursCollectionViewCell()
            }
           //cell.contentView.backgroundColor = .clear
            cell.commentText.text = testCommentText[indexPath.item]
            cell.dayText.text = testDayText[indexPath.item]
            //cell.apparalImage
            cell.hoursText.text = testHoursText[indexPath.item]
            cell.temperatureText.text = testTemText[indexPath.item]
            cell.apparelImage.image = UIImage(named: "backgroundIMG")
            //cell.apparelText.text = testText[indexPath.item]
            
            return cell
        }
        return UICollectionViewCell()
    }
        
    
}

//MARK: UICollectionViewFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {

    // 위 아래 간격
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 4
//    }

    // 옆 간격
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 4
//    }
//
//    // cell 사이즈( 옆 라인을 고려하여 설정 )
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = collectionView.frame.width / 3 - 36 ///  2등분하여 배치, 옆 간격이 12이므로 12를 빼줌
//        print("collectionView width=\(collectionView.frame.width)")
//        print("cell하나당 width=\(width)")
//        print("root view width = \(self.view.frame.width)")
//
//        let size = CGSize(width: width, height: width * 1.3)
//        return size
//    }
//
//    //cell 화면 사이드와 간격
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
}
