//
//  SearchViewController.swift
//  Weather
//
//  Created by jh on 2021/04/09.
//

import UIKit
import MapKit

protocol SearchViewDelegate {
    func sendData(data: Map)
}


class SearchViewController: UIViewController {
    var delegate: SearchViewDelegate?
    static let identifier = "SearchViewController"
    private let searchTableCellIdentifier = "searchResultCell"
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var searchResultTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    //var delegate: SearchViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchBar.showsCancelButton = true
        self.searchBar.becomeFirstResponder()
        self.searchCompleter.delegate = self
        self.searchCompleter.resultTypes = .address
        self.searchBar.delegate = self
        self.searchResultTable.dataSource = self
        self.searchResultTable.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults.removeAll()
            searchResultTable.reloadData()
        }
      // 사용자가 search bar 에 입력한 text를 자동완성 대상에 넣는다
        
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension SearchViewController: MKLocalSearchCompleterDelegate {
  // 자동완성 완료시 결과를 받는 method
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultTable.reloadData()
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
        //print(LocationError.localSearchCompleterFail)
    }
}


extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count == 0 {
            return DataManager.shared.cityList.count
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchResultTable.dequeueReusableCell(withIdentifier: searchTableCellIdentifier, for: indexPath)
        
        if searchResults.count == 0 {
            let cityList = DataManager.shared.cityList[indexPath.row]
            cell.textLabel?.text = cityList.name
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.textLabel?.text = searchResult.title
        }
        
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
  // 선택된 위치의 정보 가져오기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard searchResults.count != 0 else {
            let city: City = DataManager.shared.cityList[indexPath.row]
            let data: Map = .init(name: city.name!, latitude: city.latitude, longitude: city.longitude)
            
            self.delegate?.sendData(data: data)
            
            self.dismiss(animated: true, completion: nil)
            return
        }
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard error == nil else {
                print(error!)
                //print(LocationError.localSearchRequstFail)
                return
            }
            guard let placeMark = response?.mapItems[0].placemark else {
                return
            }
            //administrativeArea: 시
            //locality: 구
            //thorughfare: 동
            
            let name: String
            
            if placeMark.thoroughfare != nil{
                name = placeMark.thoroughfare!
            } else if placeMark.locality != nil {
                name = placeMark.locality!
            } else if placeMark.administrativeArea != nil {
                name = placeMark.administrativeArea!
            } else {
                name = placeMark.name!
            }
            
            let data = Map(name: name, latitude: placeMark.coordinate.latitude, longitude: placeMark.coordinate.longitude)
            
            DataManager.shared.addNewCity(data)
            self.delegate?.sendData(data: data)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            
            let target = DataManager.shared.cityList[indexPath.row]
            DataManager.shared.deleteCity(target)
            DataManager.shared.cityList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        }
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

