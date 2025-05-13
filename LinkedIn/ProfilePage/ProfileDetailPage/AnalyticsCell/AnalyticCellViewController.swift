//
//  AnalyticViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 12.04.2025.
//

import UIKit

class AnalyticCellViewController : UITableViewCell {
    
    
    @IBOutlet weak var profileViewsLabel: UILabel!
    @IBOutlet weak var postImpressionLabel: UILabel!
    @IBOutlet weak var searchAppearance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with analytics: [AnalyticModel]) {
        if let analytic = analytics.first {
            profileViewsLabel.text = "\(analytic.profile_views) profile views"
            postImpressionLabel.text = "\(analytic.post_impressions) post impressions"
            searchAppearance.text = "\(analytic.search_appearances) search appearances"
        }
    }
}
