//
//  KVCircleMenuButton.swift
//  TUANNM_MOVIE_21
//
//  Created by Khánh Vũ on 2/6/24.
//

import Foundation
import UIKit

protocol KVCircleMenuButtonDelegate: NSObject {
   func didSelectButton(sender: KVCircleMenuButton)
}

public class KVCircleMenuButton: UIView {
   private lazy var menuImageView: UIImageView = {
       let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
       imageView.contentMode = .scaleAspectFill
       return imageView
   }()

   weak var delegate: KVCircleMenuButtonDelegate?

   var image: UIImage? {
       didSet {
           setUpImageView()
       }
   }

    var size: CGSize? {
        didSet {
            if let size = size {
                frame.size = size
            }
        }
    }
    
    var offset: CGFloat = 0 {
        didSet {
            let sizeImage = CGSize(width: frame.size.width - offset,
                                   height: frame.size.height - offset)
            
            menuImageView.frame.size = sizeImage
            menuImageView.center = center
        }
    }

   init(image: UIImage?, size: CGSize? = nil) {
       super.init(frame: CGRect.zero)
       self.image = image
       self.size = size
       if let size = size {
           frame.size = size
       } else {
           frame.size = CGSize(width: 50, height: 50)
       }
       menuImageView.image = image
       
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
       addGestureRecognizer(tapGesture)
       addSubview(menuImageView)
   }

   required public init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

   private func setUpImageView() {
       menuImageView.image = image
   }

    @objc 
    func tap(gesture: UITapGestureRecognizer) {
       delegate?.didSelectButton(sender: gesture.view as! KVCircleMenuButton)
   }
}
