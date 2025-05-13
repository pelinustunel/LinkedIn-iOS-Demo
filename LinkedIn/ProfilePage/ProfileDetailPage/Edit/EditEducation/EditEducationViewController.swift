//
//  EditEducationViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 9.05.2025.
//

import UIKit



class EditEducationViewController: UIViewController {
    
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var fieldOfStudyTextField: UITextField!
    @IBOutlet weak var educationYearTextField: UITextField!
    
    var education: EducationModel?
    let educationViewModel = EducationViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        educationFillFields()
        
    }
    
    private func educationFillFields() {
        guard let ed = education else { return }
        schoolTextField.text = ed.school
        degreeTextField.text =  ed.degree
        fieldOfStudyTextField.text = ed.field_of_study
        educationYearTextField.text = ed.education_year
    }
    
    @IBAction func saveButton(_ sender: Any) {
            
        guard let schoolName = schoolTextField.text, !schoolName.isEmpty else {
            print("❌ education school name boş")
            return
        }
        guard let degree = degreeTextField.text, !degree.isEmpty else {
            print("❌ education degree boş")
            return
        }
        guard let fieldStudy = fieldOfStudyTextField.text, !fieldStudy.isEmpty else {
            print("❌ education field of study boş")
            return
        }
        guard let year = educationYearTextField.text, !year.isEmpty else {
            print("❌ education year boş")
            return
        }
        guard let educationId = education?.id else {
            print("❌ education ID yok")
            return
        }
        
        let educationData: [String: Any] = [
            "school": schoolName,
            "degree": degree,
            "field_of_study": fieldStudy,
            "education_year": year
        ]
        
        educationViewModel.updateEducation(id: educationId, data: educationData) { success in
            if success {
                NotificationCenter.default.post(name: .educationUpdated, object: nil)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
}

