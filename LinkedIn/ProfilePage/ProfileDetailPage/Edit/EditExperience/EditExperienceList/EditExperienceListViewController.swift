//
//  EditEducationListViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 10.05.2025.
//

import UIKit
import Alamofire
import RxSwift

class EditExperienceListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var editExperienceListTableView: UITableView!
    
    let viewModel = ExperienceViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editExperienceListTableView.delegate = self
        editExperienceListTableView.dataSource = self
        
        editExperienceListTableView.register(UINib(nibName: "EditExperienceListCell", bundle: nil), forCellReuseIdentifier: "EditExperienceListCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadExperienceList), name: .experienceUpdated, object: nil)
        
        reloadExperienceList()
    }
    
    @objc func reloadExperienceList() {
        viewModel.loadExperience()
        viewModel.experiences
            .subscribe(onNext: { [weak self] _ in
                self?.editExperienceListTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.experiences.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditExperienceListCell") as? EditExperienceListCell else {
            return UITableViewCell()
        }
        
        let experience = viewModel.experiences.value[indexPath.row]
        cell.configure(with: experience)
        
        cell.onEditTapped = { [weak self] in
            let editVC = EditExperienceViewController(nibName: "EditExperienceView", bundle: nil)
            editVC.experience = experience
            self?.navigationController?.pushViewController(editVC, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let experience = self.viewModel.experiences.value[indexPath.row]
            
            guard let experienceId = experience.id else {
                print("❌ Silinecek deneyimin ID'si yok")
                completionHandler(false)
                return
            }

            self.viewModel.deleteExperience(id: experienceId) { success in
                DispatchQueue.main.async {
                    if success {
                        self.editExperienceListTableView.reloadData()
                    }
                    completionHandler(success)
                }
            }
        }
        
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

