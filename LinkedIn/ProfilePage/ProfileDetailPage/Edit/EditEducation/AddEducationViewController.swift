//
//  AddEducationViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 9.05.2025.
//

import UIKit
import Alamofire


class AddEducationViewController: UIViewController {
    
    let educationViewModel = EducationViewModel()
    
    
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var fieldOfStudyTextField: UITextField!
    @IBOutlet weak var educationYearTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveEducation(_ sender: Any) {
        guard let school = schoolTextField.text, !school.isEmpty,
              let degree = degreeTextField.text, !degree.isEmpty,
              let field = fieldOfStudyTextField.text, !field.isEmpty,
              let year = educationYearTextField.text, !year.isEmpty else {
            print("❌ Tüm alanlar doldurulmalı.")
            return
        }
        
        educationViewModel.addEducation(
            school: school,
            degree: degree,
            fieldOfStudy: field,
            educationYear: year
        ) { success in
            DispatchQueue.main.async {
                if success {
                    // 🔔 Profil ekranına güncelleme sinyali gönder
                    NotificationCenter.default.post(name: .educationAdd, object: nil)
                    
                    // 🔙 Sayfayı kapat (push ile açıldığı için popViewController)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("❌ Eğitim eklenemedi.")
                    // Burada istersen bir alert de gösterebilirsin
                }
            }
        }
        
    }
}



