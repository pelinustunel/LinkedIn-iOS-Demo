//
//  InvitationAcceptViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 8.04.2025.
//

import UIKit

class InvitationAcceptTableCell: UITableViewCell {
    
    static let cellIdentifier = "InvitationAcceptTableCell"
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    
    func fillCell(userName: String, jobTitle: String, connectionDetail: String, date: String, image: UIImage){
        userNameLabel.text = userName
        jobLabel.text = jobTitle
        connectionLabel.text = connectionDetail
        dateLabel.text = date
        profileImageView.image = image
    }
}

