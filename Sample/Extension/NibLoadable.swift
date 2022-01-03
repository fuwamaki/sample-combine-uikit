//
//  NibLoadable.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import UIKit

protocol NibLoadable {
    static var nibName: String { get }
    static func loadNib(_ bundle: Bundle?) -> UINib
    static func instantiateFromNib(_ bundle: Bundle?) -> Self
}

extension NibLoadable {
    static var nibName: String {
        return String(describing: self)
    }

    static func loadNib(_ bundle: Bundle? = nil) -> UINib {
        let bundle = bundle ?? Bundle.main
        return UINib(nibName: nibName, bundle: bundle)
    }

    static func instantiateFromNib(_ bundle: Bundle? = nil) -> Self {
        return loadNib(bundle).instantiate(withOwner: nil, options: nil).first as! Self
    }
}
