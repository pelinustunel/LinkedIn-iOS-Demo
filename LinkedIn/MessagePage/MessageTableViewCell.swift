//
//  MessageTableViewCell.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 11.04.2025.
//

import UIKit

class MessageTableViewCell : UITableViewCell {
    
    static let cellIdentifier = "MessageTableViewCell"
    
    @IBOutlet weak var messageProfileImageView: UIImageView!
    @IBOutlet weak var messagePersonNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageProfileImageView.layer.cornerRadius = 18
        messageProfileImageView.clipsToBounds = true
        messageProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    func fillCell(profileImage : UIImage, personName : String, message : String ) {
        messageProfileImageView.image = profileImage
        messagePersonNameLabel.text = personName
        messageLabel.text = message
        
    }
    
}
