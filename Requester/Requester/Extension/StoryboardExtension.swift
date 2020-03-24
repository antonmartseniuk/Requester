//
//  StoryboardExtension.swift
//  Requester
//
//  Created by Anton Martsenyuk on 23.03.2020.
//  Copyright © 2020 Anton Martsenyuk. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "TableViewController"
}

extension UIStoryboard {
    static func mainViewController() -> TableViewController {
        UIStoryboard(.main).instantiateViewController(with: TableViewController.self)
    }
    
    convenience init(_ sb: Storyboard) {
        self.init(name: sb.rawValue, bundle: .main)
    }
    
    func instantiateViewController<T: UIViewController>(with class: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
