//
//  EditExperienceViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 9.05.2025.
//

import UIKit


class EditExperienceViewController: UIViewController {
    
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var experienceYearTextField: UITextField!
    @IBOutlet weak var workModeTextField: UITextField!
    
    var experience: ExperienceModel?
    let viewModel = ExperienceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillFields()
        
    }
    
    private func fillFields() {
        guard let exp = experience else { return }
        companyNameTextField.text = exp.company_name
        positionTextField.text = exp.position
        experienceYearTextField.text = exp.experience_year
        workModeTextField.text = exp.work_mode
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let companyName = companyNameTextField.text, !companyName.isEmpty else {
            print("❌ companyName boş")
            return
        }
        guard let position = positionTextField.text, !position.isEmpty else {
            print("❌ position boş")
            return
        }
        guard let year = experienceYearTextField.text, !year.isEmpty else {
            print("❌ year boş")
            return
        }
        guard let field = workModeTextField.text, !field.isEmpty else {
            print("❌ work mode boş")
            return
        }
        guard let experienceId = experience?.id else {
            print("❌ experience ID yok")
            return
        } 
        
        let updatedData: [String: Any] = [
            "company_name": companyName,
            "position": position,
            "experience_year": year,
            "work_mode": field,
            "company_logo": "http://127.0.0.1:5003/images/garanti.jpg"
        ]
        
        viewModel.updateExperience(id: experienceId, data: updatedData) { success in
            if success {
                NotificationCenter.default.post(name: .experienceUpdated, object: nil)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
    
    
