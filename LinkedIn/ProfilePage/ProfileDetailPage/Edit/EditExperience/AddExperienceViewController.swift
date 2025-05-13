//
//  AddExperienceViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 9.05.2025.
//

import UIKit

class AddExperienceViewController: UIViewController {
    
    let experienceViewModel = ExperienceViewModel()
    
    
    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var positionTextField: UITextField!
    
    @IBOutlet weak var experienceYearTextField: UITextField!
    
    @IBOutlet weak var workModeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func addExperienceButton(_ sender: Any) {
        guard let company = companyNameTextField.text, !company.isEmpty,
              let position = positionTextField.text, !position.isEmpty,
              let experienceYear = experienceYearTextField.text, !experienceYear.isEmpty,
              let workMode = workModeTextField.text, !workMode.isEmpty else {
            print("❌ Tüm alanlar doldurulmalı.")
            return
        }
        
        experienceViewModel.addExperience(
            companyName: company,
            position: position,
            experienceYear: experienceYear,
            workMode: workMode
        ) { success in
            DispatchQueue.main.async {
                if success {
                    NotificationCenter.default.post(name: .experienceAdd, object: nil)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("❌ Deneyim eklenemedi.")
                }
            }
        }
        
    }
}

