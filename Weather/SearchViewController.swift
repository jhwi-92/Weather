//
//  SearchViewController.swift
//  Weather
//
//  Created by jh on 2021/04/09.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {

    
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
            print("selectRow")
            //print(placeMark.coordinate.)
            print(placeMark.coordinate)
            print(placeMark.countryCode!)
            print(placeMark.title!)
            print("==========")
            //placeMark.region.self
            
            //placeMark.region
            //MKCoordinateRegion.
        
            //placeMark.coordinate
            //MKCoordinateRegion(
            
            //let coordinateSpan = MKCoordinateSpan(latitudeDelta: placeMark.coordinate.latitude, longitudeDelta: placeMark.coordinate.longitude)
            //let coordinate = MKCoordinateRegion(center: placeMark.coordinate, span: coordinateSpan)
            
            
            
            //MKCoordinateRegion(
            //MKCoordinateRegion(
            //MKCoordinateRegion(placeMark.region!)
            
            //self.delegate?
//            let coordinate = Coordinate(coordinate: placeMark.coordinate)
            
            //self.delegate?.userAdd(newLocation: Location(coordinate: coordinate, name: "\(placeMark.locality ?? selectedResult.title)"))
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
