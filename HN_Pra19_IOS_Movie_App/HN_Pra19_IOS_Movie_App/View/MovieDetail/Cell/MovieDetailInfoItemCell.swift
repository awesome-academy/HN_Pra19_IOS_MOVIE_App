//
//  MovieDetailInfoItemCell.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 7/6/24.
//

import UIKit

final class MovieDetailInfoItemCell: UICollectionViewCell {

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
    
    private var data: SearchModel?
    
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
    
    public func updateState() {
        guard let data = self.data else {
            return
        }
        
        let isWatched: Bool = CoreDataStatistics.shared.fetch(isWatched: true).contains(where: {$0.id == data.id})
        
        let isWatchList: Bool = CoreDataStatistics.shared.fetch(isWatched: false).contains(where: {$0.id == data.id})
        
        watchedLabel.textColor = isWatched ? .color19BAFF : .color787575
        watchedIcon.image = isWatched
        ? UIImage(named: "icn_watched_selected")
        : UIImage(named: "icn_watched")
        
        watchListLabel.textColor = isWatchList ? .colorFF0B8F : .color787575
        watchListIcon.image = isWatchList
        ? UIImage(named: "icn_watchlist_selected")
        : UIImage(named: "icn_watchlist")
    }
    
    public func config(_ item: SearchModel) {
        self.data = item
        self.posterImageview.setImage(item.posterURL, nil)
        self.nameLabel.text = item.getName()
        self.descLabel.text = item.overview
        self.updateState()
    }

    @IBAction func backClick(_ sender: Any) {
        onBackClick?()
    }
}
