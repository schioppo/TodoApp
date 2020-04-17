//
//  TableView.swift
//  todoApp
//
//  Created by Alessandro Schioppetti on 16/04/2020.
//  Copyright © 2020 Codermine Srl. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerNib<T: UITableViewCell>(_: T.Type) {
        register(UINib(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: String(describing: T.self))
    }
    
    func registerClass<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueClass<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
}
