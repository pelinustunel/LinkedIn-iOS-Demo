//
//  SkillCellViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 13.04.2025.
//

import UIKit

class SkillRowCellViewController : UITableViewCell {
    
    
    @IBOutlet weak var skillNameLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Kart stilini uygula
        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = true
        cardView.backgroundColor = .appBackground
        
        // (Opsiyonel) Hafif gölge
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        
    }
    
}
