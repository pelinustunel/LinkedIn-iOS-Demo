//
//  ProfileSideViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 12.04.2025.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class ProfileSideBarViewController : UIViewController {
    
    
    @IBOutlet weak var profileSideBarImageView: UIImageView!
    @IBOutlet weak var sideBarNameLabel: UILabel!
    @IBOutlet weak var sideBarJobLabel: UILabel!
    @IBOutlet weak var sideBarCountryLabel: UILabel!
    @IBOutlet weak var profileViewLabel: UILabel!
    @IBOutlet weak var postImpressionLabel: UILabel!
    @IBOutlet weak var sidePanelView: UIView!
    
    
    
    let profileViewModel = ProfileViewModel()
    let analyticSideBarViewModel = AnalyticViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideBar()
        bind()
        bindAnalytic()
        profileViewModel.loadProfile()
        analyticSideBarViewModel.loadAnalytics()
        
    }
    
    func setupSideBar() {
        profileSideBarImageView.layer.cornerRadius = profileSideBarImageView.frame.height / 2
        profileSideBarImageView.clipsToBounds = true
        
        profileSideBarImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileSideBarImageView.addGestureRecognizer(tapGesture)
    }
    
    
    func bind() {
        profileViewModel.user
            .compactMap { $0 } // 👉 Optional'ı unwrap ediyoruz
            .observe(on: MainScheduler.instance)
            .bind { [weak self] profile in
                guard let self = self else { return }
                self.sideBarNameLabel.text = profile.name
                self.sideBarJobLabel.text = profile.title
                self.sideBarCountryLabel.text = profile.location
                
                if let url = URL(string: profile.profile_picture) {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                self.profileSideBarImageView.image = UIImage(data: data)
                            }
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindAnalytic() {
        analyticSideBarViewModel.analytics
            .map { $0.first }               // 👉 ilk elemanı alıyoruz, çünkü array geliyor
            .compactMap { $0 }              // 👉 optional unwrap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] analyticSide in
                guard let self = self else { return }
                self.postImpressionLabel.text = "\(analyticSide.post_impressions)"
                self.profileViewLabel.text = "\(analyticSide.profile_views)"
            }
            .disposed(by: disposeBag)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Sidebar'ı ekran dışına yerleştir
        sidePanelView.frame.origin.x = self.view.frame.width
        
        // Animasyonla içeri al
        UIView.animate(withDuration: 0.3) {
            self.sidePanelView.frame.origin.x = self.view.frame.width - self.sidePanelView.frame.width
        }
    }
    
    @objc func profileImageTapped() {
        let profileVC = ProfileViewController()
        
        if let tabBarController = self.parent as? MainTabBarController,
           let nav = tabBarController.selectedViewController as? UINavigationController {
            
            // 1. Profile sayfasına geç
            nav.pushViewController(profileVC, animated: true)
            
            // 2. Side bar'ı kapat
            tabBarController.hideSidebar()
        } else {
            print("FNavigationController veya TabBarController bulunamadı.")
        }
    }
    
    
}

