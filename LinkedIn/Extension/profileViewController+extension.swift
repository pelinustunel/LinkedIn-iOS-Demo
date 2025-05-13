//
//  profileViewController+extension.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 9.05.2025.
//

import UIKit

extension ProfileViewController: CustomHeaderViewDelegate {
    func didTapAddButton(in headerView: CustomHeaderView, for section: Int) {
        switch section {
        case 3: // Experience
            let addExperienceVC = AddExperienceViewController(nibName: "AddExperienceView", bundle: nil)
            navigationController?.pushViewController(addExperienceVC, animated: true)
            
        case 4: // Education
            let addEducationVC = AddEducationViewController(nibName: "AddEducationView", bundle: nil)
            navigationController?.pushViewController(addEducationVC, animated: true)
            
        case 5: // Skills
            let addSkillVC = AddSkillViewController(nibName: "AddSkillView", bundle: nil)
            navigationController?.pushViewController(addSkillVC, animated: true)
            
        default:
            break
        }
    }
    
    func didTapEditButton(in headerView: CustomHeaderView, for section: Int) {
        switch section {
        case 3: // Experience
            let editExperienceVC = EditExperienceListViewController(nibName: "EditExperienceListView", bundle: nil)
            navigationController?.pushViewController(editExperienceVC, animated: true)
            
            
        case 4: // Education
            let editEducationListVC = EditEducationListViewController(nibName: "EditEducationListView", bundle: nil)
            navigationController?.pushViewController(editEducationListVC, animated: true)
            
        case 5: // Skill
            let editSkillListVC = EditSkillListViewController(nibName: "EditSkillListView", bundle: nil)
            navigationController?.pushViewController(editSkillListVC, animated: true)
            
        default:
            break
        }
    }
}
