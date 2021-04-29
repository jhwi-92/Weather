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
    //동네예보
    let serviceKey = "dP56BeIkDFP%2Bpu3BL%2FBmJMGAzYIosy%2BBxZTykiTGKFxqT6%2FR7WPOAlHS4xzUhY1f7zdgU6HHkeX6iYl4aL8Wng%3D%3D"
    //중기예보
    let serviceKey2 = "dP56BeIkDFP%2Bpu3BL%2FBmJMGAzYIosy%2BBxZTykiTGKFxqT6%2FR7WPOAlHS4xzUhY1f7zdgU6HHkeX6iYl4aL8Wng%3D%3D"
    var nowWeatherResponse: NowResponse?
    var townWeatherResponse: TownResponse?
    var jsonParser = JsonParser()
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setNavigationTitle(titleText: "위치")
        self.setNavigationBar()
        self.view.addBackground()
    }
    
    //화면에 표시되기 직전 표시(목록 업데이트 등)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.shared.fetchCity()
        guard let city: City = DataManager.shared.cityList.first else {
            return
        }
        
        let map = Map(name: city.name!, latitude: city.latitude, longitude: city.longitude)
        //초단기실황(현재기온)getUltraSrtNcst
        fetchData(data: map, type: "getUltraSrtNcst")
        
        //동네예보(오늘 하늘상태 및 3시간 간격 기온)getVilageFcst
        fetchData(data: map, type: "getVilageFcst")
        
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
    
    func fetchData(data: Map, type: String) {
        
        let baseDate = Date().toDateString(dateFormat: "yyyyMMdd")
        
        var baseTime: String
        var urlStr: String
        var key: String
        let gridXY = ConvertGrid.convertGRID_GPS(mode: "TO_GRID", lat_X: data.latitude, lng_Y: data.longitude)
        if type == "" {
            key = serviceKey2
        } else {
            key = serviceKey
        }
        //초단기예보
        if type == "getUltraSrtNcst" {
            baseTime = Date().toTimeString(timeFormat: "HH", type: type) + "00"
            urlStr = String( "http://apis.data.go.kr/1360000/VilageFcstInfoService/" + type +  "?serviceKey=" + key + "&base_date=" + baseDate + "&base_time=" + baseTime + "&nx=" + String(gridXY.x) + "&ny=" + String(gridXY.y) + "&dataType=JSON")
        } else {
            //동네예보 getVilageFcst
            baseTime = Date().toTimeString(timeFormat: "HH", type: type) + "00"
            urlStr = String( "http://apis.data.go.kr/1360000/VilageFcstInfoService/" + type +  "?serviceKey=" + serviceKey + "&base_date=" + baseDate + "&base_time=" + baseTime + "&nx=" + String(gridXY.x) + "&ny=" + String(gridXY.y) + "&dataType=JSON&pageNo=1&numOfRows=195")
        }
        setNavigationTitle(titleText: data.name)
            Network.request(urlPath: urlStr) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.jsonParser.delegate = self
                    if type == "getUltraSrtNcst" {
                        self.jsonParser.startParsing(data: data, parsingType: .now)

                    } else if type == "getVilageFcst" {
                        self.jsonParser.startParsing(data: data, parsingType: .town)

                    }
                case .failed(let error):
                    self.presentAlert(error.localizedDescription, message: "\(error.code)", completion: nil)
                
                }
            }
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
            guard let nowWeather = nowWeatherResponse  else { return UITableViewCell() }
            guard let townWeather = townWeatherResponse  else { return UITableViewCell() }
            
            guard let cell: CustomTodayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as? CustomTodayTableViewCell else {return CustomTodayTableViewCell()}
            cell.modifyCell(nowInfo: nowWeather.response.body!.items.TEM[0], townInfo: townWeather.response.body!.items.SKY[0])
            return cell
        } else if indexPath.row == 1 {
  
            guard let cell: CustomCollectionViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "inCollectionCell", for: indexPath) as? CustomCollectionViewTableViewCell else {return CustomCollectionViewTableViewCell()}
            
            cell.collectionView?.delegate = self
            cell.collectionView?.dataSource = self
            cell.collectionView.tag = indexPath.row
            
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
            
            return cell
        }
        return UITableViewCell()
    }
}
//MARK: UICollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //self.tableView.
        if collectionView.tag == 1 {
            return testText.count
        } else if collectionView.tag == 2 {
            guard let count: Int = self.townWeatherResponse?.response.body?.items.T3H.count else {return 0}
            return count
        } else if collectionView.tag == 3 {
            guard let tmnCount: Int = self.townWeatherResponse?.response.body?.items.TMN.count else {return 0}
            
            let count: Int = tmnCount + 0
            return count
        } else {return 1}
        //return testText.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            guard let cell: CustomApparelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "apparelCell", for: indexPath) as? CustomApparelCollectionViewCell else {
                return UICollectionViewCell()
            }
           //추후 다시! 이미지필요
            cell.apparelImage.image = UIImage(named: "backgroundIMG")
            cell.apparelText.text = testText[indexPath.item]
            
            return  cell
        } else if collectionView.tag == 2 {
            guard let townWeather = townWeatherResponse  else { return UICollectionViewCell() }
            
            guard let cell: CustomThreeHoursCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "threeHoursCell", for: indexPath) as? CustomThreeHoursCollectionViewCell else {
                return CustomThreeHoursCollectionViewCell()
            }
            
            cell.modifyCell(townItem: townWeather.response.body!.items, index: indexPath.row)
            
            return cell
        } else if collectionView.tag == 3 {
            guard let townWeather = townWeatherResponse  else { return UICollectionViewCell() }
            
            guard let cell: CustomWeekCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCollectionCell", for: indexPath) as? CustomWeekCollectionViewCell else {
                return CustomWeekCollectionViewCell()
            }
            
            cell.layer.cornerRadius = 10;
            cell.modifyCell(townItem: townWeather.response.body!.items, index: indexPath.row)
            
            return cell
        }
        return UICollectionViewCell()
    }
        
    
}

//MARK: UICollectionViewFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {

}

extension ViewController: JsonParserDelegate {
    func parsingDidFinished<T>(result: T, parsingType: JsonParser.ParsingType) {
        switch parsingType {
        case .now:
            nowWeatherResponse = result as? NowResponse
            guard nowWeatherResponse != nil else { return }
            guard nowWeatherResponse?.response.body != nil else {
                presentAlert("알림", message: (nowWeatherResponse?.response.header.resultMsg)!, completion: nil)
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        case .town:
            townWeatherResponse = result as? TownResponse
            guard townWeatherResponse != nil else { return }
            guard townWeatherResponse?.response.body != nil else {
                presentAlert("알림", message: (townWeatherResponse?.response.header.resultMsg)!, completion: nil)
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

extension ViewController: SearchViewDelegate {
    func sendData(data: Map) {
        
//        DataManager.shared.fetchCity()
//        guard let city: City = DataManager.shared.cityList.first else {
//            return
//        }
//
//        let map = Map(name: .name!, latitude: city.latitude, longitude: city.longitude)
        //초단기실황(현재기온)getUltraSrtNcst
        fetchData(data: data, type: "getUltraSrtNcst")
        
        //동네예보(오늘 하늘상태 및 3시간 간격 기온)getVilageFcst
        fetchData(data: data, type: "getVilageFcst")
   }
}
