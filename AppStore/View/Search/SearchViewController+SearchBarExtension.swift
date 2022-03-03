//
//  SearchViewController+SearchBarExtension.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/03/01.
//

import UIKit

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {    // searchBar text 변경될 시
        guard let text = searchController.searchBar.text else {
            return
        }
        
        searchViewModel.fetchHistory(term: text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchViewModel.changeCollectionViewType(type: .History)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.changeCollectionViewType(type: .Recent)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        // 최근 검색단어 리스트에 추가
        searchViewModel.addRecentSearchTerm(text: text)
        
        // 앱 검색 request
        searchViewModel.fetchApps(term: text)
    }
    
}
