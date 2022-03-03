//
//  SearchList.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/02/27.
//

import Foundation

struct SearchList: Codable {
    let resultCount: Int?
    let results: [Search]?
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}
