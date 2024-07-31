//
//  MovieDetailHeaderView.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 8/6/24.
//

import UIKit
enum HeaderDetailState {
    case billCast
    case poster
}

class MovieDetailHeaderView: UICollectionReusableView {
    @IBOutlet private var topBillCastButton: UIButton!
    @IBOutlet private var posterButton: UIButton!
    
    var onBillCastClick: (() -> Void)?
    var onPosterClick: (() -> Void)?
    
    var state: HeaderDetailState = .billCast {
        didSet {
            updateState()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    private func setUpUI() {
        state = .billCast
    }
    
    private func updateState() {
        topBillCastButton.setTitleColor(state == .billCast ? .black : .color787575, for: .normal)
        posterButton.setTitleColor(state == .poster ? .black : .color787575, for: .normal)
    }
    
    @IBAction func topBillCastClick(_ sender: Any) {
        state = .billCast
        onBillCastClick?()
    }
    
    @IBAction func posterClick(_ sender: Any) {
        state = .poster
        onPosterClick?()
    }
}
