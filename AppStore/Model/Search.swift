//
//  Photo.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/02/25.
//

import Foundation

struct Search: Codable {
    let screenshotUrls: [String]
    let artworkUrl512: String
    let averageUserRating: Double?
    let trackContentRating: String
    let releaseDate: String
    let trackName: String
    let currentVersionReleaseDate: String
    let releaseNotes: String?
    let description: String
    let artistName: String
    let genres: [String]
    let version: String
    let userRatingCount: Int
//    let artistViewUrl: String
//    let artworkUrl60: String
//    let artworkUrl100: String
//    let ipadScreenshotUrls: [String]
//    let appletvScreenshotUrls: [String]
//    let features: [String]
//    let advisories: [String]
//    let isGameCenterEnabled: Bool
//    let supportedDevices: [String]
//    let kind: String
//    let trackCensoredName: String
//    let trackViewUrl: String
//    let contentAdvisoryRating: String
//    let minimumOsVersion: String
//    let languageCodesISO2A: [String]
//    let fileSizeBytes: String
//    let sellerUrl: String
//    let formattedPrice: String?
//    let averageUserRatingForCurrentVersion: Double
//    let userRatingCountForCurrentVersion: Int
//    let isVppDeviceBasedLicensingEnabled: Bool
//    let bundleId: String
//    let sellerName: String
//    let primaryGenreName: String
//    let genreIds: [String]
//    let trackId: Int
//    let primaryGenreId: Int
//    let currency: String
//    let artistId: Int
//    let price: Double
//    let wrapperType: String
    
    enum CodingKeys: String, CodingKey {
        case screenshotUrls
        case artworkUrl512
        case averageUserRating
        case trackContentRating
        case releaseDate
        case trackName
        case currentVersionReleaseDate
        case releaseNotes
        case description
        case artistName
        case genres
        case version
        case userRatingCount
//        case artistViewUrl
//        case artworkUrl60
//        case artworkUrl100
//        case ipadScreenshotUrls
//        case appletvScreenshotUrls
//        case features
//        case advisories
//        case isGameCenterEnabled
//        case supportedDevices
//        case kind
//        case trackCensoredName
//        case trackViewUrl
//        case contentAdvisoryRating
//        case minimumOsVersion
//        case languageCodesISO2A
//        case fileSizeBytes
//        case sellerUrl
//        case formattedPrice
//        case averageUserRatingForCurrentVersion
//        case userRatingCountForCurrentVersion
//        case isVppDeviceBasedLicensingEnabled
//        case bundleId
//        case sellerName
//        case primaryGenreName
//        case genreIds
//        case trackId
//        case primaryGenreId
//        case currency
//        case artistId
//        case price
//        case wrapperType
    }
}
