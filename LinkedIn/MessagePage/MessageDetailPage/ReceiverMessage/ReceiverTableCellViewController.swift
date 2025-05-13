//
//  ReceiverMessageViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 17.04.2025.
//

import UIKit

class ReceiverTableCellViewController : UITableViewCell {
    
    
    @IBOutlet weak var messageDetailProfileImage: UIImageView!
    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var receiverMessageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageDetailProfileImage.layer.cornerRadius = messageDetailProfileImage.frame.height / 2
        messageDetailProfileImage.clipsToBounds = true
        
    }  
}
