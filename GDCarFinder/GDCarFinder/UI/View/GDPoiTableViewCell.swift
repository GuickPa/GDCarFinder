//
//  GDPoiTableCellView.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 27/05/22.
//

import UIKit

class GDPoiTableViewCell: UITableViewCell {
    static let reuseIdentifier:String = "poi.cell.gd.it"
    
    @IBOutlet weak var containerPicView:UIView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var conditionLabel:UILabel!
    @IBOutlet weak var positionLabel:UILabel!
    @IBOutlet weak var iconView:UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.iconView.image = nil
        self.conditionLabel.text = nil
        self.positionLabel.text = nil
    }
    
}
