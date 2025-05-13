//
//  HomeViewCell.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 8.04.2025.
//

import UIKit

class HomeViewCell : UITableViewCell {
    
    
    @IBOutlet weak var UserNameTextField: UILabel!
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var mentionLabel: UILabel!
    @IBOutlet weak var interactionNumbers: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mentionLabel.numberOfLines = 0
        mentionLabel.lineBreakMode = .byWordWrapping
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(hex: "#1C1C1E")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0))
    }
    
    
    func fillCell(userName: String, job : String, date: String, mention: String, interactionNumber: String, image: UIImage, postImage : UIImage) {
        UserNameTextField.text = userName
        JobLabel.text = job
        
        mentionLabel.text = mention
        interactionNumbers.text = interactionNumber
        profileImage.image = image
        postImageView.image = postImage
    }
    
}
