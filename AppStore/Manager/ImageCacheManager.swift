//
//  ImageCacheManager.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/02/25.
//

import UIKit

class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
