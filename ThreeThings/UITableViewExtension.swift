//
//  UITableViewExtension.swift
//  LetToDo
//
//  Created by xuemincai on 16/9/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var reusIdentifier: String { get }
}

extension ReusableView {
    
    static var reusIdentifier: String  {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableView { }

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.reusIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reusIdentifier)")
        }
        
        return cell
        
    }
    
}

extension UICollectionViewCell: ReusableView { }

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reusIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reusIdentifier)")
        }
        
        return cell
        
    }
    
}
