//
//  InvitationViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 8.04.2025.
//

import UIKit

class InvitationTableCell : UITableViewCell {
    
    
    @IBOutlet weak var invitationCountLabel: UILabel!
    @IBOutlet weak var invitationCountDetailButton: UIButton!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var onDetailClick: (() -> Void)?
    
    @IBAction func detailClick(_ sender: Any) {
        onDetailClick?()
    }
}
