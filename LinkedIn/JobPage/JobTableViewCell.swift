//
//  JobTableViewCell.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 10.04.2025.
//

import UIKit

class JobTableViewCell : UITableViewCell {
    
    static let cellIdentifier = "JobTableViewCell"
    
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var jobCompanyNameLabel: UILabel!
    @IBOutlet weak var jobCountryNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        jobImageView.layer.cornerRadius = 18
        jobImageView.clipsToBounds = true
        jobImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func fillCell (jobName : String, jobCompany : String, jobCountry: String, image : UIImage){
        jobNameLabel.text = jobName
        jobCompanyNameLabel.text = jobCompany
        jobCountryNameLabel.text = jobCountry
        jobImageView.image = image
    }
}
