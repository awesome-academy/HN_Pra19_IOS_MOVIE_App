//
//  PhotoItemCell.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 8/6/24.
//

import UIKit

final class PhotoItemCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.isHidden = true
    }
    
    func config(_ url: String?) {
        photoImageView.setImage(url ?? "", nil)
    }
    
    func configActor(_ item: SearchModel) {
        titleLabel.isHidden = false
        photoImageView.setImage(item.posterURL, nil)
        titleLabel.text = item.originalTitle
    }
}
