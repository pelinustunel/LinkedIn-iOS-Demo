//
//  ProfileCellViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 12.04.2025.
//

import UIKit

class ProfileCellViewController : UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileJobNameLabel: UILabel!
    @IBOutlet weak var profileEducationLabel: UILabel!
    @IBOutlet weak var profileCountryNameLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var addSectionButton: UIButton!
    @IBOutlet weak var enchanceProfileButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var openToButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        
    }
    
    func configure(with profile: ProfileModel) {
        profileNameLabel.text = profile.name
        profileJobNameLabel.text = profile.title
        profileEducationLabel.text = profile.education
        profileCountryNameLabel.text = profile.location
        connectionLabel.text = "\(profile.connection) connections"
        
        if let profileImageURL = URL(string: profile.profile_picture) {
            profileImageView.setNeedsLayout()
            profileImageView.layoutIfNeeded()
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
            profileImageView.clipsToBounds = true
            profileImageView.contentMode = .scaleAspectFill
            // Eğer görseli burada yüklemek istiyorsan, Kingfisher veya URLSession ile resmi indirmen gerek.
        }
    }

}

