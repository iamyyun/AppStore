//
//  NetworkManager.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/02/25.
//

import Foundation
import UIKit

protocol NetworkManagerDelegate: AnyObject {
    func didReceiveNetworking(isSuccess: Bool, result: String, data: Data)
}

let baseURL: String = "https://itunes.apple.com/search"

class NetworkManager {
    // MARK: - Constants
    let urlSession = URLSession(configuration: .default)
    
    // MARK: - Variables And Properties
    weak var networkDelegate: NetworkManagerDelegate?
    var dataTask: URLSessionDataTask?
    var imageTask: URLSessionDataTask?
    var errorMessage = ""
    
    // MARK: - Type Alias
    typealias JSONDictionary = [String: Any]
    
    // MARK: - Methods
    func searchApps(data: Dictionary<String, Any>) {
        self.makeRequest(url: baseURL, data: data)
    }
    
    func downloadImage(url: URL, completion: @escaping ((UIImage?, Bool) -> Void)) {
        guard imageTask == nil else { return }
        
        let cacheKey = NSString(string: url.absoluteString) // 캐시에 사용될 Key 값
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) { // 해당 Key 에 캐시이미지가 저장되어 있으면 이미지를 사용
            completion(cachedImage, true)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let _ = err {
                DispatchQueue.main.async {
                    completion(UIImage(), true)
                }
                return
            }
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    ImageCacheManager.shared.setObject(image, forKey: cacheKey) // 다운로드된 이미지를 캐시에 저장
                    completion(image, true)
                }
            }
        }.resume()
    }
    
    // MARK: - Private Methods
    private func makeRequest(url: String, data: Dictionary<String, Any>) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: url) {
            urlComponents.queryItems = data.map { URLQueryItem(name: $0, value: String(describing: $1)) }

            guard let targetUrl = urlComponents.url else {
                return
            }

            dataTask = urlSession.dataTask(with: targetUrl) { (data, response, error) in

                defer {
                    self.dataTask = nil
                }

                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                }

                guard let httpResponse = response as? HTTPURLResponse else { return }

                let statusCode = httpResponse.statusCode
                if statusCode == 200 {
                    self.networkDelegate?.didReceiveNetworking(isSuccess: true, result: "Success", data: data!)
                } else {
                    self.networkDelegate?.didReceiveNetworking(isSuccess: false, result: "Fail", data: Data())
                }
            }
            dataTask?.resume()
        }
    }
}
