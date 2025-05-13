//
//  JobDetailViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 10.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class JobDetailViewController : UIViewController {
    
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var jobCompanyLabel: UILabel!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var jobCountryLabel: UILabel!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var jobSkillLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var jobAllDescription: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    var jobModel: JobModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "JobDetailSheet"
        
        
        // Varsayılan ayarlar
        jobAllDescription.numberOfLines = 0
        jobAllDescription.lineBreakMode = .byWordWrapping
        
        if let job = jobModel {
            jobNameLabel.text = job.title
            jobCompanyLabel.text = job.company
            jobCountryLabel.text = job.location
            
            if let skill = job.skill, !skill.isEmpty {
                jobSkillLabel.text = skill
            } else {
                jobSkillLabel.text = "Yetenek bilgisi bulunamadı"
            }
            
            // Açıklamayı formatlı göster
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            
            let attributedText = NSAttributedString(string: job.description ?? "Açıklama bulunamadı",
                                                    attributes: [
                                                        .paragraphStyle: paragraphStyle,
                                                        .font: UIFont.systemFont(ofSize: 15)
                                                    ])
            jobAllDescription.attributedText = attributedText

            // Şirket logosunu yükle
            if let logoURL = job.company_logo, let url = URL(string: logoURL) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.jobImageView.image = image
                        }
                    }
                }.resume()
            }
        }
        
    }
    
}
