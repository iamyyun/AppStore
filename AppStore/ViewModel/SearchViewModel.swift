//
//  SearchViewModel.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/03/01.
//

import UIKit

enum CollectionType: Int {
    case Recent = 0
    case History
    case Search
}

class SearchViewModel: NetworkManagerDelegate {
    
    let recentSearchKey = "RecentResearch"      // userDefaults key
    private let networkManager: NetworkManager
    
    var collectionType: CollectionType? = .Recent
    var searchResults: [Search] = []        // 검색결과
    var recentTerms: Array<String> = []     // 최근 검색단어
    var historyTerms: Array<String> = []    // 최근 검색단어 히스토리
    
    var reloadData: (() -> Void)?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.networkManager.networkDelegate = self
        
        recentTerms = getRecentSearchTerm()
    }
    
    // MARK: - Methods
    func fetchApps(term: String) {  // 앱 검색
        let param = ["term":term, "country":"KR", "media":"software"] as [String: Any]
        networkManager.searchApps(data: param)
    }
    
    func fetchHistory(term: String) {   // 최근 검색 단어 중 검색어에 해당하는 단어 불러오기
        historyTerms.removeAll()
        
        if recentTerms.count > 0 {
            for i in 0...recentTerms.count-1 {
                if recentTerms[i].contains(term) {
                    historyTerms.append(recentTerms[i])
                }
            }
        }
        
        self.reloadData?()
    }
    
    func changeCollectionViewType(type: CollectionType) {
        historyTerms.removeAll()
        recentTerms = getRecentSearchTerm()
        collectionType = type
        
        self.reloadData?()
    }
    
    // MARK: - UserDefaults Methods
    func addRecentSearchTerm(text: String) {    // 최근검색단어에 추가
        
        let defaults = UserDefaults.standard
        var recentSearch = defaults.stringArray(forKey: recentSearchKey) ?? [String]()
        if recentSearch.count > 0 {
            for i in 0...recentSearch.count-1 {
                if recentSearch[i] == text {
                    recentSearch.remove(at: i)
                    break
                }
            }
        }
        
        recentSearch.append(text)
        defaults.set(recentSearch, forKey: recentSearchKey)
    }
    
    func getRecentSearchTerm() -> Array<String> {   // 최근 검색단어 불러오기
        let defaults = UserDefaults.standard
        let recentSearch = defaults.stringArray(forKey: recentSearchKey) ?? [String]()
        return recentSearch
    }
    
    // MARK: - NetworkManagerDelegate
    func didReceiveNetworking(isSuccess: Bool, result: String, data: Data) {
        print("didReceiveNetworking : ", isSuccess ? "success":"fail")
        
        if isSuccess {
            guard let decoded = try?
                    JSONDecoder().decode(SearchList.self, from: data) else {
                        print("error")
                        return }
            
            searchResults.removeAll()
            searchResults.append(contentsOf: decoded.results!)
            collectionType = .Search
            
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
}
