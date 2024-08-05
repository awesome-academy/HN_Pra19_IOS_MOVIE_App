//
//  HomeItemCell.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 8/6/24.
//

import UIKit

final class HomeItemCell: UICollectionViewCell {

    @IBOutlet weak private var bottomView: ShadowImageView!
    @IBOutlet weak private var midView: ShadowImageView!
    @IBOutlet weak private var topView: ShadowImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        Utils.clearCache()
    }

    private func setUpUI() {
        self.layer.masksToBounds = false
        self.contentView.layer.masksToBounds = false
        bottomView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        midView.transform = CGAffineTransform(rotationAngle: -.pi / 10)
        
        [topView, midView, bottomView].forEach { img in
            img?.setLayout(radius: 30,
                           shadowColor: .black,
                           shadowOpacity: 0.4,
                           shadowOffset: .zero,
                           shadowRadius: 10)
            img?._borderColor = .white
            img?._borderWidth = 6
        }
    }
    
    func config(_ item: SearchModel) {
        topView.setImage(item.posterURL)
        midView.setImage(item.backdropURL)
        bottomView.setImage(item.backdropURL)
        nameLabel.text = item.getTitle()
        dateLabel.text = item.getReleaseDate()
    }
}
