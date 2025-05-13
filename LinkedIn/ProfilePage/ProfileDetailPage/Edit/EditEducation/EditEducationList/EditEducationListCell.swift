//
//  EditEducationListCell.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 10.05.2025.
//

import UIKit

class EditEducationListCell : UITableViewCell {
    
    @IBOutlet weak var educationImageView: UIImageView!
    @IBOutlet weak var educationNameLabel: UILabel!
    @IBOutlet weak var bachelorLabel: UILabel!
    @IBOutlet weak var educationDateLabel: UILabel!
    @IBOutlet weak var fieldLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    var onEditTapped: (() -> Void)? 
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: EducationModel) {
        educationNameLabel.text = model.school
        bachelorLabel.text = model.degree
        educationDateLabel.text = model.education_year
        fieldLabel.text = model.field_of_study
        
        // Görsel varsa yükle
        if let imageUrl = model.education_image, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.educationImageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    
    @IBAction func editClickButton(_ sender: Any) {
        onEditTapped?() // 👈 Tıklanınca dışarı bildir
    }
    
    
}
