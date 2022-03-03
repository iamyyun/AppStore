//
//  DetailViewController+CollectionViewExtension.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/03/01.
//

import UIKit

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search.screenshotUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let screenCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenShotCollectionViewCell", for: indexPath) as? ScreenShotCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let imageUrl = URL(string: search.screenshotUrls[indexPath.item])!
        networkManager.downloadImage(url: imageUrl, completion: {
            image, isSuccess in
            DispatchQueue.main.async {
                screenCell.screenImage.image = image
                screenCell.screenImage.layer.cornerRadius = 20
                screenCell.screenImage.sizeToFit()
            }
        })
        return screenCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 230, height: 450)
    }
    
}
