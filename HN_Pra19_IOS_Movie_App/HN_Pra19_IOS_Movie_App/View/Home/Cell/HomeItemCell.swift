//
//  HomeItemCell.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 8/6/24.
//

import UIKit

final class HomeItemCell: UICollectionViewCell {

    @IBOutlet weak private var bottomImageView: UIImageView!
    @IBOutlet weak private var midImageView: UIImageView!
    @IBOutlet weak private var topImageView: UIImageView!
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
        bottomImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        midImageView.transform = CGAffineTransform(rotationAngle: -.pi / 10)
    }
    
    func config(_ item: SearchModel) {
        topImageView.setImage(item.posterURL, nil) { [unowned self] img in
            self.midImageView.image = img
            self.bottomImageView.image = img
        }
        nameLabel.text = item.getTitle()
        dateLabel.text = item.getReleaseDate()
    }
}
