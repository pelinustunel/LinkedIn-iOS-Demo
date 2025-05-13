//
//  ExperienceCellViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 13.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

class ExperienceCellViewController : UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var experienceTableView: UITableView!
    
    let disposeBag = DisposeBag()
    var experiences: [ExperienceModel] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        experienceTableView.delegate = self
        experienceTableView.dataSource = self
        
        experienceTableView.register(UINib(nibName: "ExperienceRowCellView", bundle: nil), forCellReuseIdentifier: "ExperienceRowCellView")
        
    }
    
    func configure(with experiences: [ExperienceModel]) {
        self.experiences = experiences
        experienceTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceRowCellView", for: indexPath) as! ExperienceRowCellViewController
        let experience = experiences[indexPath.row]
        
        cell.jobNameLabel.text = experience.company_name
        cell.detailCompanyNameLabel.text = experience.position
        cell.dateLabel.text = experience.experience_year
        cell.workAboutLabel.text = experience.work_mode
        
        if let imageUrlString = experience.company_logo,
           let url = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.companyImageView.image = image
                    }
                }
            }.resume()
        } else {
            cell.companyImageView.image = UIImage(named: "school")
        }

        return cell
    }
    
}
