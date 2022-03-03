//
//  SearchViewModelTests.swift
//  AppStoreTests
//
//  Created by Yunju Yang on 2022/03/01.
//

import XCTest
@testable import AppStore

class SearchViewModelTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var searchViewModel: SearchViewModel!
    
    
    override func setUpWithError() throws {
        self.networkManager = NetworkManager()
        self.searchViewModel = SearchViewModel(networkManager: NetworkManager())
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        self.searchViewModel = nil
        self.networkManager = nil
        super .tearDown()
    }
    
    func testUserDefaults() {
        let term = "카카오뱅크"
        searchViewModel.addRecentSearchTerm(text: term)
        
        let result = searchViewModel.getRecentSearchTerm()
        XCTAssertEqual(result[result.count-1], term)
    }
}
