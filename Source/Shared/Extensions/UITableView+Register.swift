//
//  UITableView+Register.swift
//  Scout
//
//

import UIKit

extension UITableView {
    
    func register<Cell: UITableViewCell>(_ cell: Cell.Type) {
        let bundle = Bundle(for: cell.self)
        let identifier = String(describing: cell.self)
        let nib = UINib(nibName: identifier, bundle: bundle)

        self.register(nib, forCellReuseIdentifier: identifier)
    }

    func dequeue<Cell: UITableViewCell>(_ cell: Cell.Type, for index: IndexPath) -> Cell {
        let identifier = String(describing: cell.self)

        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: index) as? Cell else {
            fatalError("Cannot dequeue cell with identifier: \(identifier)")
        }

        return cell
    }
}
