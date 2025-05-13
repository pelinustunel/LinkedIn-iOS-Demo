//
//  EditSkillViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 13.05.2025.
//

import UIKit

class EditSkillViewController : UIViewController {
    
    
    @IBOutlet weak var skillNameTextField: UITextField!
    
    var skill: SkillModel?
    let editSkillViewModel = SkillViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillFields()
        
    }
    
    private func fillFields() {
        guard let skill = skill else { return }
        skillNameTextField.text = skill.name
    }
    
    @IBAction func skillSaveButton(_ sender: Any) {
        guard let skillName = skillNameTextField.text, !skillName.isEmpty else {
            print("❌ skillName boş")
            return
        }
        
        guard let skillId = skill?.id else {
            print("❌ skill ID yok")
            return
        }
        
        let updatedData: [String: Any] = [
            "name": skillName,
        ]
        
        editSkillViewModel.updateSkill(id: skillId, data: updatedData) { success in
            if success {
                NotificationCenter.default.post(name: .skillUpdate, object: nil)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
  
    }
}
