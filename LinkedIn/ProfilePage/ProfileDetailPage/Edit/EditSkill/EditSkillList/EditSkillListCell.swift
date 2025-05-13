//
//  EditSkillListCell.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 13.05.2025.
//

import UIKit

class EditSkillListCell : UITableViewCell {
    
    
    @IBOutlet weak var editSkillNameLabel: UILabel!
    
    
    var onEditTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: SkillModel) {
        editSkillNameLabel.text = model.name
    }
    
    
    @IBAction func skillEditClickButton(_ sender: Any) {
        onEditTapped?()
    }
    
}
