//
//  DetailViewController.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/02/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newTextView: UITextView!
    @IBOutlet weak var newMoreBtn: UIButton!
    @IBOutlet weak var screenCollectionView: UICollectionView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var descMoreBtn: UIButton!
    @IBOutlet weak var sellerLabel: UILabel!
    
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var newViewHeight: NSLayoutConstraint!
    @IBOutlet weak var newTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descTextViewHeight: NSLayoutConstraint!
    
    let networkManager = NetworkManager()
    
    var search: Search!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        // data set up
        setUpData()
    }
    
    func setUpData() {
        // textView padding 설정
        newTextView.textContainerInset = .zero
        descTextView.textContainerInset = .zero
        newTextView.textContainer.lineFragmentPadding = 0
        descTextView.textContainer.lineFragmentPadding = 0
        
        // 앱이름 높이 조정
        titleLabel.text = search.trackName
        let size = CGSize(width: titleLabel.frame.width, height: .infinity)
        let estimatedSize = titleLabel.sizeThatFits(size)
        titleLabelHeight.constant = estimatedSize.height
        
        descLabel.text = search.artistName
        ratingLabel.text = String(format: "%.1f", search.averageUserRating ?? 0.0)
        countLabel.text = (Parser.default.getRatingCount(ratingCount: search.userRatingCount) ?? "")+"개의 평가"
        genreLabel.text = search.genres[0]
        ageLabel.text = search.trackContentRating
        versionLabel.text = "버전 "+search.version
        dateLabel.text = Parser.default.getUpdateDate(date: search.currentVersionReleaseDate)
        sellerLabel.text = search.artistName
        
        // release notes - height 조정
        newTextView.text = search.releaseNotes
        let newSize = CGSize(width: newTextView.frame.width, height: .infinity)
        let newEstimatedSize = newTextView.sizeThatFits(newSize)
        if newEstimatedSize.height < newTextViewHeight.constant {
            newMoreBtn.alpha = 0
            let newHeight = newTextViewHeight.constant - newEstimatedSize.height
            newViewHeight.constant = newViewHeight.constant - newHeight
            newTextViewHeight.constant = newEstimatedSize.height
        }
        
        // description - height 조정
        descTextView.text = search.description
        let descSize = CGSize(width: descTextView.frame.width, height: .infinity)
        let descEstimatedSize = descTextView.sizeThatFits(descSize)
        if descEstimatedSize.height < descTextViewHeight.constant {
            descMoreBtn.alpha = 0
            let descHeight = descTextViewHeight.constant - descEstimatedSize.height
            descViewHeight.constant = descViewHeight.constant - descHeight
            descTextViewHeight.constant = descEstimatedSize.height
        }
        
        // rating
        starStackView.arrangedSubviews.forEach {
            if let iv = $0 as? UIImageView {
                iv.image = UIImage(systemName: "star")
            }
        }
        
        let ratingCount = search.averageUserRating ?? 0
        
        let integerRatingCount = Int(ratingCount)
        let floatingRatingCount = ratingCount - Double(integerRatingCount)

        (0...integerRatingCount - 1).forEach { (idx) in
            if let imgView = starStackView.arrangedSubviews[idx] as? UIImageView {
                imgView.image = UIImage(systemName: "star.fill")
            }
        }

        if floatingRatingCount > 0.5 {
            if let imgView = starStackView.arrangedSubviews[integerRatingCount] as? UIImageView {
                imgView.image = UIImage(systemName: "star.lefthalf.fill")
            }
        }
        
        // icon image url
        let iconUrl = URL(string: search.artworkUrl512)!
        networkManager.downloadImage(url: iconUrl, completion: {
            image, isSuccess in
            DispatchQueue.main.async {
                self.iconImage.image = image
                self.iconImage.sizeToFit()
            }
        })
    }
    
    // MARK: - Actions
    @IBAction func newMoreBtnAction(_ sender: Any) {
        newMoreBtn.alpha = 0
        
        // 내용이 더 있는 경우에 height 조정
        let size = CGSize(width: newTextView.frame.width, height: .infinity)
        let estimatedSize = newTextView.sizeThatFits(size)
        
        let viewHeight = estimatedSize.height - newTextViewHeight.constant
        newViewHeight.constant = newViewHeight.constant + viewHeight
        newTextViewHeight.constant = estimatedSize.height
    }
    
    @IBAction func descMoreBtnAction(_ sender: Any) {
        descMoreBtn.alpha = 0
        
        // 내용이 더 있는 경우에 height 조정
        let size = CGSize(width: descTextView.frame.width, height: .infinity)
        let estimatedSize = descTextView.sizeThatFits(size)
        
        let viewHeight = estimatedSize.height - descTextViewHeight.constant
        descViewHeight.constant = descViewHeight.constant + viewHeight
        descTextViewHeight.constant = estimatedSize.height
    }
}
