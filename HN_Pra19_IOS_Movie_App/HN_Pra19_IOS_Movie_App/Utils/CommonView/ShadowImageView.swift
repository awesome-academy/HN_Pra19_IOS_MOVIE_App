//
//  ShadowImageView.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 5/8/24.
//

import Foundation
import UIKit

class ShadowImageView: UIView {

    private let imageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func setImage(_ urlStr: String) {
        imageView.setImage(urlStr, nil)
    }
    
    func setLayout(radius: CGFloat,
                   shadowColor: UIColor?,
                   shadowOpacity: Float,
                   shadowOffset: CGSize,
                   shadowRadius: CGFloat) {
        imageView.layer.cornerRadius = radius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.cornerRadius = radius
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
}

