//
//  MovieDetailInfoItemCell.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 7/6/24.
//

import UIKit

class MovieDetailInfoItemCell: UICollectionViewCell {

    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var watchListLabel: UILabel!
    @IBOutlet private weak var watchListIcon: UIImageView!
    @IBOutlet private weak var watchListStv: UIStackView!
    @IBOutlet private weak var playTrailerIcon: UIImageView!
    @IBOutlet private weak var posterImageview: UIImageView!
    @IBOutlet private weak var watchedLabel: UILabel!
    @IBOutlet private weak var watchedIcon: UIImageView!
    @IBOutlet private weak var watchedStv: UIStackView!
    
    var onBackClick: (() -> Void)?
    var onWatchedClick: (() -> Void)?
    var onWatchListClick: (() -> Void)?
    var onPlayTrailerClick: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    private func setUpUI() {
        watchedStv.addTapGestureRecognizer { [weak self] _ in
            self?.onWatchedClick?()
        }
        
        watchListStv.addTapGestureRecognizer { [weak self] _ in
            self?.onWatchListClick?()
        }
        
        playTrailerIcon.addTapGestureRecognizer { [weak self] _ in
            self?.onPlayTrailerClick?()
        }
    }
    
    func config(_ item: SearchModel) {
        self.posterImageview.setImage(item.posterURL, nil)
        self.nameLabel.text = item.getName()
        self.descLabel.text = item.overview
        
        watchedLabel.textColor = .color787575
        watchedIcon.image = UIImage(named: "icn_watched")
        
        watchListLabel.textColor = .color787575
        watchListIcon.image = UIImage(named: "icn_watchlist")
    }

    @IBAction func backClick(_ sender: Any) {
        onBackClick?()
    }
}
