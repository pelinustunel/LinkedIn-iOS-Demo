//
//  SenderTableCellViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 17.04.2025.
//

import UIKit


class SenderTableCellViewController : UITableViewCell {
    
    
    @IBOutlet weak var senderProfileImage: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderMessageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        senderProfileImage.layer.cornerRadius = senderProfileImage.frame.height / 2
        senderProfileImage.clipsToBounds = true
        
    }
   
}


