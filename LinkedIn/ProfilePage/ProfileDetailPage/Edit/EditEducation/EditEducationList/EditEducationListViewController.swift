//
//  EditEducationListViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 10.05.2025.
//

import UIKit
import RxSwift
import Alamofire

class EditEducationListViewController : UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var editListTableView: UITableView!
    
    
    let educationViewModel = EducationViewModel()
    let disposeBag = DisposeBag()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editListTableView.delegate = self
        editListTableView.dataSource = self
        
        editListTableView.register(UINib(nibName: "EditEducationListCell", bundle: nil), forCellReuseIdentifier: "EditEducationListCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadExperienceList), name: .educationUpdated, object: nil)
        
        reloadExperienceList()

    }
    
    @objc func reloadExperienceList() {
        educationViewModel.loadEducations()
        educationViewModel.educations
            .subscribe(onNext: { [weak self] _ in
                self?.editListTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return educationViewModel.educations.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditEducationListCell") as? EditEducationListCell else {
            return UITableViewCell()
        }
        
        let education = educationViewModel.educations.value[indexPath.row]
        cell.configure(with: education)
        
        cell.onEditTapped = { [weak self] in
            let editVC = EditEducationViewController(nibName: "EditEducationView", bundle: nil)
            editVC.education = education
            self?.navigationController?.pushViewController(editVC, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let education = self.educationViewModel.educations.value[indexPath.row]
            
            guard let educationId = education.id else {
                print("❌ Silinecek deneyimin ID'si yok")
                completionHandler(false)
                return
            }

            self.educationViewModel.deleteExperience(id: educationId) { success in
                DispatchQueue.main.async {
                    if success {
                        self.editListTableView.reloadData()
                    }
                    completionHandler(success)
                }
            }
        }
        
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

