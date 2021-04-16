//
//  ViewController.swift
//  Weather
//
//  Created by jh on 2021/04/05.
//

import UIKit

class ViewController: UIViewController {
    
  

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBAction func plusButton(_ sender: Any) {
        print("plusButton")
    }
    
    @IBAction func menuButton(_ sender: Any) {
        print("menuButton")
    }
    @IBOutlet var tableView: UITableView!
    var map: Map?
    //var city: City? = nil
    let testText:[String?] = ["트렌치코트","잠바","패딩","아아","어어"]
    let testDayText:[String?] = ["04/07","04/08","04/08","04/08","04/08","04/08","04/08","04/08"]
    let testHoursText:[String?] = ["21시","00시","03시","06시","09시","12시","15시","18시"]
    let testTemText:[String?] = ["11C","9C","6C","4C","10C","15C","16C","14C"]
    let testCommentText:[String?] = ["맑아요","흐려요","흐려요","흐려요","흐려요","맑아요","맑아요","맑아요"]
    let testWeekText:[String?] = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
    var weatherResponse: response?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //DataManager.shared.fetchCity()
        // Do any additional setup after loading the view.
//        let url = String(format: "https://api.darksky.net/forecast//%lf,%lf?lang=ko", 12.333, 154.44)
//
//        print("11")
//        print(url)
        //presentAlert("알림", message: "test", completion: nil)

        self.tableView.dataSource = self
        self.tableView.delegate = self
        //self.view.collection
        //self.tableView.rowHeight = 200
        
        self.setNavigationTitle(titleText: "위치")
        self.setNavigationBar()
        self.view.addBackground()
        //navigationItem.title =
    }
    
    //화면에 표시되기 직전 표시(목록 업데이트 등)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.shared.fetchCity()
        print(DataManager.shared.cityList)
        guard let city: City = DataManager.shared.cityList.first else {
            return
        }
        
        let map = Map(name: city.name!, latitude: city.latitude, longitude: city.longitude)
        sendData(data: map)
        
        //배열에 저장된 데이터로 데이터 호출
        //tableView.reloadData()

    }
    
    //title 을 버튼형식으로 변경
    func setNavigationTitle(titleText: String) {
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = .clear
        button.setTitle(titleText, for: .normal)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = button
    }

    //네비게이션 바 투명하도록
    func setNavigationBar(){
            let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    
    @objc func clickOnButton() {
        print("title Click")
        guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {return}
        vcName.modalTransitionStyle = .coverVertical
        vcName.delegate = self
        self.present(vcName, animated: true, completion: nil)
        
    }
    
    func setTemData() {
        
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
        return 4
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            guard let cell: CustomTodayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as? CustomTodayTableViewCell else {return CustomTodayTableViewCell()}
            //guard self.weatherResponse? != nil as? CustomTodayTableViewCell else {return CustomTodayTableViewCell()}
            //guard let nilCheck = self.weatherResponse else {return }
            if self.weatherResponse != nil {
                let tem = ConvertGrid.temSearch(type: "T1H", data: (self.weatherResponse?.response.body.items.item)!)
                print("tem")
                print(tem)
                cell.averageText.text = "현재"
                cell.todayText.text = Date().toDateString(dateFormat: "M월 d일 HH시")
                cell.temperature.text = tem
                cell.comment.text = "오늘은 흐린날이에요... 가디건 추천드려요"
                cell.temperatureSymbol.text = "℃"
            }
            return cell
        } else if indexPath.row == 1 {
  
            guard let cell: CustomCollectionViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "inCollectionCell", for: indexPath) as? CustomCollectionViewTableViewCell else {return CustomCollectionViewTableViewCell()}
            
            cell.collectionView?.delegate = self
            cell.collectionView?.dataSource = self
            
            cell.collectionView.tag = indexPath.row
            //cell.collectionView?.backgroundColor = UIColor.init(red: 10, green: 10, blue: 10, alpha: 1)
            
            return cell
        } else if indexPath.row == 2 {
            
            guard let cell: CustomThreeHoursCollectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "threeHoursCell", for: indexPath) as? CustomThreeHoursCollectionTableViewCell else {return CustomThreeHoursCollectionTableViewCell()}
            
            cell.collectionView?.delegate = self
            cell.collectionView?.dataSource = self
            
            cell.collectionView.tag = indexPath.row
            //cell.collectionView?.backgroundColor = UIColor.init(red: 10, green: 10, blue: 10, alpha: 1)
            
            return cell
        } else if indexPath.row == 3 {
         
            guard let cell: CustomWeekCollectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "weekTableCell", for: indexPath) as? CustomWeekCollectionTableViewCell else {return CustomWeekCollectionTableViewCell()}
            
            cell.collectionView?.delegate = self
            cell.collectionView?.dataSource = self
            
            cell.collectionView.tag = indexPath.row
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
        if collectionView.tag == 1 {
            return testText.count
        } else if collectionView.tag == 2 {
            return testHoursText.count
        } else if collectionView.tag == 3 {
            return 7
        } else {return 1}
        //return testText.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            guard let cell: CustomApparelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "apparelCell", for: indexPath) as? CustomApparelCollectionViewCell else {
                return UICollectionViewCell()
            }
           //cell.contentView.backgroundColor = .clear
            cell.apparelImage.image = UIImage(named: "backgroundIMG")
            cell.apparelText.text = testText[indexPath.item]
            
            return  cell
        } else if collectionView.tag == 2 {
            //collectionView.register(CustomThreeHoursCollectionViewCell.self, forCellWithReuseIdentifier: "threeHoursCell")
            guard let cell: CustomThreeHoursCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "threeHoursCell", for: indexPath) as? CustomThreeHoursCollectionViewCell else {
                return CustomThreeHoursCollectionViewCell()
            }
            
           //cell.contentView.backgroundColor = .clear
            cell.commentText.text = testCommentText[indexPath.item]!
            cell.dayText.text = testDayText[indexPath.item]
            //cell.apparalImage
            cell.hoursText.text = testHoursText[indexPath.item]
            cell.temperatureText.text = testTemText[indexPath.item]
            cell.apparelImage.image = UIImage(named: "backgroundIMG")
            //cell.apparelText.text = testText[indexPath.item]
            
            return cell
        } else if collectionView.tag == 3 {
            guard let cell: CustomWeekCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCollectionCell", for: indexPath) as? CustomWeekCollectionViewCell else {
                return CustomWeekCollectionViewCell()
            }
            
           //cell.contentView.backgroundColor = .clear
            //cell.dayText.text = testCommentText[indexPath.item]
            //셀 모서리 굴곡
            cell.layer.cornerRadius = 10;
            //cell.layer.masksToBounds = YES;

            cell.dayText.text = testWeekText[indexPath.item]
            //cell.apparalImage
            cell.maxText.text = "최고"
            cell.minText.text = "최저"
            cell.maxTemperature.text = "20도"
            cell.minTemperature.text = "10도"
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

extension ViewController: SearchViewDelegate {
    func sendData(data: Map) {

        print("vc")
        print(data.latitude)
        print(data.longitude)
        print(data.name)
        setNavigationTitle(titleText: data.name)
        let serviceKey = "dP56BeIkDFP%2Bpu3BL%2FBmJMGAzYIosy%2BBxZTykiTGKFxqT6%2FR7WPOAlHS4xzUhY1f7zdgU6HHkeX6iYl4aL8Wng%3D%3D"
        let baseDate = Date().toDateString(dateFormat: "yyyyMMdd")
        
        let baseTime = Date().toTimeString(timeFormat: "HH") + "00"
        

        //Network.request(urlPath: urlStr, completion: <#T##(Network.NetworkResult) -> ()#>)
        let gridXY = ConvertGrid.convertGRID_GPS(mode: "TO_GRID", lat_X: data.latitude, lng_Y: data.longitude)
        
        let urlStr = String( "http://apis.data.go.kr/1360000/VilageFcstInfoService/getUltraSrtNcst" + "?serviceKey=" + serviceKey + "&base_date=" + baseDate + "&base_time=" + baseTime + "&nx=" + String(gridXY.x) + "&ny=" + String(gridXY.y) + "&dataType=JSON")
        
        print("urlStr")
        print(urlStr)
        //let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getUltraSrtNcst?"
        
        
        Network.request(urlPath: urlStr) { [weak self] result in
                    guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                do {
                    let apiResponse: response = try JSONDecoder().decode(response.self, from: data)
                    self.weatherResponse = apiResponse
                    print(self.weatherResponse)
                    let tem = ConvertGrid.temSearch(type: "T1H", data: (self.weatherResponse?.response.body.items.item)!)
                    print("tem")
                    print(tem)
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                    //self.tableView.reloadData()
                } catch(let err) {
                    print(err)
                }
                        //self.jsonParser.delegate = self
                        //self.jsonParser.startParsing(data: data, parsingType: .detail, conciseCity: self.city)
            case .failed(let error):
                        print(error)
//                        if let data = UserDefaults.standard.value(forKey: self.city.name) as? Data {
//                            if let city = try? PropertyListDecoder().decode(DetailCity.self, from: data) {
//                                self.detailCity = city
//                                DispatchQueue.main.async { [weak self] in
//                                    self?.weatherDetailTableView.reloadData()
//                                }
//                            }
//                        } else {
//                            self.presentAlert(error.localizedDescription, message: "\(error.code)", completion: nil)
//                        }
                    }
                }
        

       }


}
