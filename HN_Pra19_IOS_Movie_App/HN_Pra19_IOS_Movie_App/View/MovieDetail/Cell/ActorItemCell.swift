//
//  ActorItemCell.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 7/6/24.
//

import UIKit

class ActorItemCell: UICollectionViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    private var colums: CGFloat = isIphone() ? 3 : 5
    private var spacing: CGFloat = isIphone() ? 12 : 25
    private var padding: CGFloat = isIphone() ? 17 : 40
    
    override func prepareForReuse() {
        super.prepareForReuse()
        Utils.clearCache()
    }
    
    func config(_ item: CastModel) {
        let width = Int((getWindowSize().width - 2 * padding - (colums - 1) * spacing) / colums)
        avatarImageView._cornerRadius = CGFloat((width - 32) / 2)
        self.avatarImageView.setImage(item.posterURL, nil)
        self.nameLabel.text = item.name
    }
    
    func config(_ item: ActorModel) {
        spacing = isIphone() ? 20 : 40
        colums = isIphone() ? 2 : 5
        let width = Int((getWindowSize().width - 2 * padding - (colums - 1) * spacing) / colums)
        avatarImageView._cornerRadius = CGFloat((width - 32) / 2)
        self.avatarImageView.setImage(item.profileURL, nil)
        self.nameLabel.text = item.name
    }
}
