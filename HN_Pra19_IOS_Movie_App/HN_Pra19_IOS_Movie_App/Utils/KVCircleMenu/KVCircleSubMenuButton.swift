//
//  KVCircleSubMenuButton.swift
//  TUANNM_MOVIE_21
//
//  Created by Khánh Vũ on 2/6/24.
//

import Foundation
import UIKit

protocol KVCircleSubMenuButtonProtocol {
   var index: Int { get set }
   var startPosition: CGPoint? { get set }
   var endPosition: CGPoint? { get set }
}

public class KVCircleSubMenuButton: KVCircleMenuButton, KVCircleSubMenuButtonProtocol {
   var index = 0
   var startPosition: CGPoint?
   var endPosition: CGPoint?
}
