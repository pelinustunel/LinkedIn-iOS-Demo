//
//  AddSkillViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 9.05.2025.
//

import UIKit


class AddSkillViewController: UIViewController {
    
    @IBOutlet weak var skillTextField: UITextField!
    
    let skillViewModel = SkillViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func skillSaveButton(_ sender: Any) {
        guard let name = skillTextField.text, !name.isEmpty
            else {
            print("❌ Tüm alanlar doldurulmalı.")
            return
        }
        
        skillViewModel.addSkill(
            name: name,
        ) { success in
            DispatchQueue.main.async {
                if success {
                    NotificationCenter.default.post(name: .skillAdd, object: nil)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("❌ Deneyim eklenemedi.")
                }
            }
        }
    }
    
}



