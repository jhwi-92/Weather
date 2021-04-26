//
//  SearchViewController.swift
//  Weather
//
//  Created by jh on 2021/04/09.
//

import UIKit
import MapKit

protocol SearchViewDelegate {
    func sendData(data: Map, type: String)
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
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        let cell = searchResultTable.dequeueReusableCell(withIdentifier: searchTableCellIdentifier, for: indexPath)
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
  // 선택된 위치의 정보 가져오기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            
            let data = Map(name: CLPlacemark.init(placemark: placeMark).thoroughfare!, latitude: placeMark.coordinate.latitude, longitude: placeMark.coordinate.longitude)
            
            print("1")
            print(CLPlacemark.init(placemark: placeMark).thoroughfare)
            
            //test.name = CLPlacemark.init(placemark: placeMark).thoroughfare!
            //test.longitude = placeMark.coordinate.longitude
            //test.latitude = placeMark.coordinate.latitude
            //test.latitude = 1.11
            DataManager.shared.addNewCity(data)
            //self.delegate?.sendData(data: data)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

