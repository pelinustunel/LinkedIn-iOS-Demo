//
//  EducationCellViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 13.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

class EducationCellViewController : UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var educationTableView: UITableView!
    
    let disposeBag = DisposeBag()
    var educations: [EducationModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        educationTableView.delegate = self
        educationTableView.dataSource = self
        
        educationTableView.register(UINib(nibName: "EducationRowCellView", bundle: nil), forCellReuseIdentifier: "EducationRowCellViewController")
        
    }
    
    func configure(with educations: [EducationModel]) {
        self.educations = educations
        educationTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return educations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EducationRowCellViewController", for: indexPath) as! EducationRowCellViewController
        let education = educations[indexPath.row]
        
        cell.educationNameLabel.text = education.school
        cell.bachelorLabel.text = education.degree
        cell.educationDateLabel.text = education.education_year
        cell.fieldLabel.text = education.field_of_study
        
        if let imageUrlString = education.education_image,
           let url = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.educationImageView.image = image
                    }
                }
            }.resume()
        } else {
            // Backend'den image gelmezse fallback
            cell.educationImageView.image = UIImage(named: "school")
        }

        
        return cell
    }
    
}
