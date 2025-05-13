//
//  EditEducationListCell.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 10.05.2025.
//

import UIKit

class EditExperienceListCell : UITableViewCell {
    
    
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var detailCompanyNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var workAboutLabel: UILabel!
    
    
    var onEditTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: ExperienceModel) {
        jobNameLabel.text = model.position
        detailCompanyNameLabel.text = model.company_name
        dateLabel.text = model.experience_year
        workAboutLabel.text = model.work_mode
        
        // Görsel yükleme
        if let imageUrl = model.company_logo, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.companyImageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    @IBAction func editClickButton(_ sender: Any) {
        onEditTapped?()
    }
    
}
