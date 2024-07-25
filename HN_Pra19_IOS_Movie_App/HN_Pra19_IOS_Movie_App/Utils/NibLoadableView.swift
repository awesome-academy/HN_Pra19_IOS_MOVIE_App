//
//  NibLoadableView.swift
//  TUANNM_MOVIE_17
//
//  Created by Khánh Vũ on 13/5/24.
//

import Foundation
import UIKit

public protocol ReusableView: AnyObject { }

public extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

public protocol NibLoadableView: AnyObject { }

public extension NibLoadableView where Self: UIView {
    
    static var nibName: String {
        // notice the new describing here
        // now only one place to refactor if describing is removed in the future
        return String(describing: self)
    }
    
}

extension UIViewController: NibLoadableView { }
extension UITableViewCell: NibLoadableView { }
extension UITableViewCell: ReusableView { }
extension UICollectionReusableView: ReusableView { }
extension UICollectionReusableView: NibLoadableView { }
extension UITableViewHeaderFooterView: NibLoadableView { }
extension UITableViewHeaderFooterView: ReusableView { }

public extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type, bundle: Foundation.Bundle? = nil) {
        
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerHeaderFooterNib<T: UITableViewHeaderFooterView>(_: T.Type, bundle: Foundation.Bundle? = nil) {
        
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue view with identifier: \(T.reuseIdentifier)")
        }
        
        return view
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}


public extension UICollectionView {
    func deselectAllItems(animated: Bool) {
        for cell in visibleCells {
            cell.isSelected = false
        }
    }
    
    func deselectAllItems(section: Int, animated: Bool) {
        let indexPathsInSection = (0..<numberOfItems(inSection: section)).map { IndexPath(item: $0, section: section) }

        for indexPath in indexPathsInSection {
            deselectItem(at: indexPath, animated: false)
        }
    }
    
    func register<T: UICollectionViewCell>(_: T.Type, bundle: Foundation.Bundle? = nil) {
        
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(_: T.Type,supplementaryViewType:String? = UICollectionView.elementKindSectionHeader, bundle: Foundation.Bundle? = nil) {
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        self.register(nib, forSupplementaryViewOfKind: supplementaryViewType!, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    func dequeueReusableView<T: UICollectionReusableView>(kind:String,forIndexPath indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue view with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
}


extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
