//
//  SearchViewController.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/02/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let networkManager = NetworkManager()
    let searchViewModel = SearchViewModel(networkManager: NetworkManager())
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "검색"
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        searchViewModel.reloadData = {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailViewController else { return }
        
        if let index = sender as? IndexPath {
            vc.search = searchViewModel.searchResults[index.item]
        }
    }
}
