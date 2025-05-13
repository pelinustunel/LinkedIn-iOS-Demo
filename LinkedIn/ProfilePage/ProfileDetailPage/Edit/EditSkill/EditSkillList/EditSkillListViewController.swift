//
//  EditSkillListViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 13.05.2025.
//

import UIKit
import Alamofire
import RxSwift


class EditSkillListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource  {
    

    @IBOutlet weak var editSkillTableView: UITableView!
    
    let editSkillViewModel = SkillViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editSkillTableView.delegate = self
        editSkillTableView.dataSource = self
        
        editSkillTableView.register(UINib(nibName: "EditSkillListCell", bundle: nil), forCellReuseIdentifier: "EditSkillListCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSkillList), name: .skillUpdate, object: nil)
        
        reloadSkillList()
    }
    
    @objc func reloadSkillList() {
        editSkillViewModel.loadSkills()
        editSkillViewModel.skills
            .subscribe(onNext: { [weak self] _ in
                self?.editSkillTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editSkillViewModel.skills.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditSkillListCell") as? EditSkillListCell else {
            return UITableViewCell()
        }
        
        let skill = editSkillViewModel.skills.value[indexPath.row]
        cell.configure(with: skill)
        
        cell.onEditTapped = { [weak self] in
            let skillVC = EditSkillViewController(nibName: "EditSkillView", bundle: nil)
            skillVC.skill = skill
            self?.navigationController?.pushViewController(skillVC, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let skill = self.editSkillViewModel.skills.value[indexPath.row]
            
            guard let skillId = skill.id else {
                print("❌ Silinecek deneyimin ID'si yok")
                completionHandler(false)
                return
            }

            self.editSkillViewModel.deleteSkill(id: skillId) { success in
                DispatchQueue.main.async {
                    if success {
                        self.editSkillTableView.reloadData()
                    }
                    completionHandler(success)
                }
            }
        }
        
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
