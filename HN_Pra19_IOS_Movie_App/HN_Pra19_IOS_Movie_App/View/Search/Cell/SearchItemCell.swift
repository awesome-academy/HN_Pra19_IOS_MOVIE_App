//
//  SearchItemCell.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 7/6/24.
//

import UIKit

final class SearchItemCell: UITableViewCell {

    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        Utils.clearCache()
    }
    
    private func setUpUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func config(_ item: SearchModel) {
        nameLabel.text = item.getName()
        posterImageView.setImage(item.posterURL, nil)
        categoryLabel.text = item.getReleaseDate()
    }
}
