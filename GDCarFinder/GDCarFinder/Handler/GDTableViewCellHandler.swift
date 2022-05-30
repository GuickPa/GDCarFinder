//
//  GDTableCellHandler.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 27/05/22.
//

import Foundation
import UIKit

protocol GDTableViewCellHandler {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, withItem item: GDPoi)
}

class GDPoiTableViewCellHandler: GDTableViewCellHandler {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GDPoiTableViewCell.reuseIdentifier, for: indexPath) as! GDPoiTableViewCell
        cell.prepareForReuse()
        cell.contentView.backgroundColor = GDConst.cellBGColor0
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, withItem item: GDPoi) {
        // TODO: fill cell data
        if let c = cell as? GDPoiTableViewCell {
            c.nameLabel.text = "\(item.type) ID \(item.id)"
            c.conditionLabel.text = item.state
            c.positionLabel.text = "\(item.coordinate.latitude) \(item.coordinate.longitude)"
        }
    }
}
