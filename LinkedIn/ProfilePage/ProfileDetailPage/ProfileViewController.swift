//
//  ProfileViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 12.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class ProfileViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profileTableView: UITableView!
    let educationViewModel = EducationViewModel()
    let experinceViewModel = ExperienceViewModel()
    let skillViewModel = SkillViewModel()
    let activityViewModel = ActivityViewModel()
    let analyticViewModel = AnalyticViewModel()
    let profileViewModel = ProfileViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        profileTableView.backgroundColor = UIColor(hex: "#1C1C1E")
        
        setupTableView()
        
        bindEducationViewModel()
        educationViewModel.loadEducations()
        
        bindExperienceViewModel()
        experinceViewModel.loadExperience()
        
        bindSkillViewModel()
        skillViewModel.loadSkills()
        
        bindActivityViewModel()
        activityViewModel.loadActivities()
        
        bindAnalyticViewModel()
        analyticViewModel.loadAnalytics()
        
        bindProfileViewModel()
        profileViewModel.loadProfile()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadEducations), name: .educationAdd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadEducations), name: .educationUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadExperiences), name: .experienceAdd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadExperiences), name: .experienceUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSkills), name: .skillAdd, object: nil)
        
    
        
    }
    
    @objc func reloadEducations() {
        educationViewModel.loadEducations()
    }
    
    @objc func reloadExperiences() {
        experinceViewModel.loadExperience()
    }
    
    @objc func reloadSkills() {
        skillViewModel.loadSkills()
    }
    
    private func setupTableView() {
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.backgroundColor = UIColor(hex: "#1C1C1E")
        
        profileTableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        
        profileTableView.register(UINib(nibName: "ProfileCellView", bundle: nil), forCellReuseIdentifier: "ProfileCellViewController")
        profileTableView.register(UINib(nibName: "AnalyticCellView", bundle: nil), forCellReuseIdentifier: "AnalyticCellViewController")
        profileTableView.register(UINib(nibName: "ActivityCellView", bundle: nil), forCellReuseIdentifier: "ActivityCellViewController")
        profileTableView.register(UINib(nibName: "ExperienceCellView", bundle: nil), forCellReuseIdentifier: "ExperienceCellView")
        profileTableView.register(UINib(nibName: "EducationCellView", bundle: nil), forCellReuseIdentifier: "EducationCellViewController")
        profileTableView.register(UINib(nibName: "SkillCellView", bundle: nil), forCellReuseIdentifier: "SkillCellViewController")
    }
    
    private func bindEducationViewModel() {
        educationViewModel.educations
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.profileTableView.reloadSections(IndexSet(integer: 4), with: .automatic)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindExperienceViewModel() {
        experinceViewModel.experiences
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.profileTableView.reloadSections(IndexSet(integer: 3), with: .automatic)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSkillViewModel() {
        skillViewModel.skills
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.profileTableView.reloadSections(IndexSet(integer: 5), with: .automatic)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindActivityViewModel() {
        activityViewModel.activities
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.profileTableView.reloadSections(IndexSet(integer: 5), with: .automatic)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAnalyticViewModel() {
        analyticViewModel.analytics
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.profileTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindProfileViewModel () {
        profileViewModel.user
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.profileTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            })
            .disposed(by: disposeBag)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCellViewController", for: indexPath) as! ProfileCellViewController
            let profile = profileViewModel.user.value
            
            if let profile = profile {  // ✅ Optional'ı unwrap ettik!
                cell.configure(with: profile)
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnalyticCellViewController", for: indexPath) as! AnalyticCellViewController
            let analyticList = analyticViewModel.analytics.value
            cell.configure(with: analyticList)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCellViewController", for: indexPath) as! ActivityCellViewController
            let activityList = activityViewModel.activities.value
            cell.configure(with: activityList)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCellView", for: indexPath) as! ExperienceCellViewController
            let experienceList = experinceViewModel.experiences.value
            cell.configure(with: experienceList)
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EducationCellViewController", for: indexPath) as! EducationCellViewController
            let educationList = educationViewModel.educations.value
            cell.configure(with: educationList)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillCellViewController", for: indexPath) as! SkillCellViewController
            let skillList = skillViewModel.skills.value
            cell.configure(with: skillList)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 350
        case 1:
            return 260
        case 2:
            return 350
        case 3:
            let experienceCount = experinceViewModel.experiences.value.count
            return CGFloat(max(1, experienceCount)) * 100  // Her experience için 100, en az 1 tane
        case 4:
            let educationCount = educationViewModel.educations.value.count
            return CGFloat(max(1, educationCount)) * 100  // Her education için 100, en az 1 tane
        case 5:
            let skillCount = skillViewModel.skills.value.count
            return CGFloat(max(1, skillCount)) * 40      // Her skill için 57, en az 1 tane
        default:
            return 100
        }
    }
    
    
    // viewForHeaderInSection metodunu güncelleyin
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as? CustomHeaderView else {
            return nil
        }
        
        headerView.delegate = self
        headerView.tag = section // Section bilgisini tag olarak kaydediyoruz
        
        switch section {
        case 3:
            headerView.headerLabel.text = "Experience"
            headerView.editButton.isHidden = false
            headerView.addButton.isHidden = false
            
        case 4:
            headerView.headerLabel.text = "Education"
            headerView.editButton.isHidden = false
            headerView.addButton.isHidden = false
            
        case 5:
            headerView.headerLabel.text = "Skills"
            headerView.editButton.isHidden = false
            headerView.addButton.isHidden = false
            
        default:
            headerView.editButton.isHidden = true
            headerView.addButton.isHidden = true
            return nil
        }
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 || section == 4 || section == 5 {
            return 60
        }
        return 0
    }
    
    
    // Boşluk kontrolü (footer kısmı)
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 // işte burası o boşluk
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(hex: "#1C1C1E") // senin arka plan renginle uyumlu olsun
        return footerView
    }
    
    
}


