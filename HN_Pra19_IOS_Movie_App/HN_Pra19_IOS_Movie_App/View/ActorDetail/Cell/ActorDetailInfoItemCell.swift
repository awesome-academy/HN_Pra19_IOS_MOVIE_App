//
//  ActorDetailInfoItemCell.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 8/6/24.
//

import UIKit

final class ActorDetailInfoItemCell: UICollectionViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avataImagrView: UIImageView!
    @IBOutlet private weak var biographyLabel: UILabel!
    
    var onBackClick: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(_ item: ActorModel?) {
        nameLabel.text = item?.name
        biographyLabel.text = item?.biography
        avataImagrView.setImage(item?.profileURL ?? "", nil)
    }
    
    @IBAction func backClick(_ sender: Any) {
        onBackClick?()
    }
}
