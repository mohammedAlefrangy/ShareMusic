//
//  SearchVC.swift
//  ShareMusic
//
//  Created by Mohammed on 8/17/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit
import Alamofire

class SearchVC: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView :UITableView!
    var itemsSearchViedo = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init search bar in the screen
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.isTranslucent = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Share Music Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    
    func initViewData(){
           initTableView()
       }
    
    // get data from youtube search api and show in table View
    func getDataFromYoutube(keyWord: String){
        let requestSearch =
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyWord)&maxResults=4&order=viewCount&key=\(APIConfig.apiKey2)"
        AF.request(requestSearch).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                let jsonObject = json as! [String:Any]
                let kind = jsonObject["kind"] as? String
                if kind != nil {
                    let items = jsonObject["items"] as! NSArray
                    let allitems = try! JSONSerialization.data(withJSONObject: items, options: [])
                    let decoder = JSONDecoder()
                    self.itemsSearchViedo.append(contentsOf: try! decoder.decode([Video].self, from: allitems))
                    print(self.itemsSearchViedo.count)
                    self.tableView.reloadData()
                    self.initViewData()
                    
                }else{
                    let errorMessage = jsonObject["error"] as! Any
                    let message = errorMessage
                    print(message)
                }
                
                break
            case .failure(let error):
                print("Error is: \(error.localizedDescription)")
            }
        }
    }
    
    
}



extension SearchVC: UISearchResultsUpdating {
    
    // When user search for any keyWords show new results
    func updateSearchResults(for searchController: UISearchController) {
        
        print(searchController.searchBar.text)
        let term = searchController.searchBar.text
        
        if  !(term?.elementsEqual(""))!{
            print(term)
            self.itemsSearchViedo.removeAll()
            let keyWordSearch = String(term!.lowercased().filter { !" \n\t\r".contains($0) })
            
            // send keyWords to getDataFromYoutube method to get data
            getDataFromYoutube(keyWord: keyWordSearch)
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsSearchViedo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCVC", for: indexPath) as! SearchCVC
                
        cell.nameVideo.text = itemsSearchViedo[indexPath.row].snippet?.title
        let url = URL(string: itemsSearchViedo[indexPath.row].snippet?.thumbnails?.high?.url ?? "")
        cell.imageVideo.downloadedFrom(url: url!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // When user selsect any row open friend screen and send ID for Video
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FriendVC") as! FriendVC
        vc.videdId = self.itemsSearchViedo[indexPath.row].id?.videoID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
