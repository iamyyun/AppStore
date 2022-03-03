//
//  SearchViewController+CollectionViewExtension.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/03/01.
//

import UIKit

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch searchViewModel.collectionType {
        case .Recent:   // 최근 검색 단어 cell
            searchController?.isActive = true
            let term = searchViewModel.recentTerms[indexPath.item]
            searchViewModel.addRecentSearchTerm(text: term)
            
            searchViewModel.fetchApps(term: term)
        case .History:  // 최근 검색 단어 중 해당단어 검색 cell
            searchController?.searchBar.endEditing(true)
            let term = searchViewModel.historyTerms[indexPath.item]
            searchViewModel.addRecentSearchTerm(text: term)
            
            searchViewModel.fetchApps(term: term)
        case .Search:   // 검색 결과 cell
            performSegue(withIdentifier: "SearchToDetail", sender: indexPath)
        case .none:
            break;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        switch searchViewModel.collectionType {
        case .Recent:   // 최근 검색 단어 cell
            count = searchViewModel.recentTerms.count
        case .History:  // 최근 검색 단어 중 해당단어 검색 cell
            count = searchViewModel.historyTerms.count
        case .Search:   // 검색 결과 cell
            count = searchViewModel.searchResults.count
        case .none:
            break
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = UICollectionViewCell()
        switch searchViewModel.collectionType {
        case .Recent:   // 최근 검색 단어 cell
            guard let recentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCollectionViewCell", for: indexPath) as? RecentCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            // recent term
            let term = searchViewModel.recentTerms[indexPath.item]
            recentCell.termLabel.text = term
            
            return recentCell
        case .History:  // 최근 검색 단어 중 해당단어 검색 cell
            guard let historyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as? HistoryCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            // history term
            let term = searchViewModel.historyTerms[indexPath.item]
            historyCell.termLabel.setTitle(term, for: .normal)
            
            return historyCell
        case .Search:   // 검색 결과 cell
            guard let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            let searchResult: Search = searchViewModel.searchResults[indexPath.item]
            
            searchCell.titleLabel.text = searchResult.trackName
            searchCell.descLabel.text = searchResult.artistName
            searchCell.countLabel.text = Parser.default.getRatingCount(ratingCount: searchResult.userRatingCount)
            
            // icon image url
            let iconUrl = URL(string: searchResult.artworkUrl512)!
            networkManager.downloadImage(url: iconUrl, completion: {
                image, isSuccess in
                DispatchQueue.main.async {
                    searchCell.iconImage.image = image
                    searchCell.iconImage.sizeToFit()
                }
            })
            
            // rating
            searchCell.ratingStackView.arrangedSubviews.forEach {
                if let iv = $0 as? UIImageView {
                    iv.image = UIImage(systemName: "star")
                }
            }
            
            let ratingCount = searchResult.averageUserRating ?? 0
            
            let integerRatingCount = Int(ratingCount)
            let floatingRatingCount = ratingCount - Double(integerRatingCount)

            (0...integerRatingCount - 1).forEach { (idx) in
                if let imgView = searchCell.ratingStackView.arrangedSubviews[idx] as? UIImageView {
                    imgView.image = UIImage(systemName: "star.fill")
                }
            }

            if floatingRatingCount > 0.5 {
                if let imgView = searchCell.ratingStackView.arrangedSubviews[integerRatingCount] as? UIImageView {
                    imgView.image = UIImage(systemName: "star.lefthalf.fill")
                }
            }
            
            // screenshots image url
            for (i,v) in
                    searchCell.screenShotStackView.arrangedSubviews.enumerated() {
                guard let iv = v as? UIImageView else { continue }
                
                let screenUrl = URL(string: searchResult.screenshotUrls[i])!
                networkManager.downloadImage(url: screenUrl, completion: {
                    image, isSuccess in
                    DispatchQueue.main.async {
                        iv.image = image
                        iv.layer.cornerRadius = 15
                        iv.clipsToBounds = true
                    }
                })
            }
            
            return searchCell
        case .none:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch searchViewModel.collectionType {
        case .Recent:   // 최근 검색 단어 cell
            return CGSize(width: collectionView.frame.width, height: 40)
        case .History:  // 최근 검색 단어 중 해당단어 검색 cell
            return CGSize(width: collectionView.frame.width, height: 35)
        case .Search:   // 검색 결과 cell
            return CGSize(width: collectionView.frame.width, height: 353)
        case .none:
            break
        }
        return CGSize(width: 0, height: 0)
    }
    
}
