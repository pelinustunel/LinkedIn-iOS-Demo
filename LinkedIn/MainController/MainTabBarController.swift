//
//  File.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 7.04.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let topBar = TopBarView()
    private var previousIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTabBarAppearance()
        setupNavigationBarAppearance()
        setupTopBar()
    }
    
    private func setupViewControllers() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let networkVC = UINavigationController(rootViewController: NetworkViewController())
        networkVC.tabBarItem = UITabBarItem(title: "Network", image: UIImage(systemName: "person.2"), tag: 1)
        
        let dummyPostVC = UIViewController()
        dummyPostVC.view.backgroundColor = .appBackground
        dummyPostVC.tabBarItem = UITabBarItem(title: "Post", image: UIImage(systemName: "plus.app"), tag: 2)
        
        let notificationVC = UINavigationController(rootViewController: NotificationViewController())
        notificationVC.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: 3)
        
        let jobsVC = UINavigationController(rootViewController: JobViewController())
        jobsVC.tabBarItem = UITabBarItem(title: "Jobs", image: UIImage(systemName: "briefcase"), tag: 4)
        
        viewControllers = [homeVC, networkVC, dummyPostVC, notificationVC, jobsVC]
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#21293A")
        
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.backgroundColor = UIColor(hex: "#21293A")
    }
    
    private func setupNavigationBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hex: "#21293A")
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func setupTopBar() {
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        topBar.onChatButtonTapped = { [weak self] in
            let messageVC = MessageViewController()
            messageVC.view.backgroundColor = .systemBackground
            messageVC.title = "Messages"
            
            if let nav = self?.selectedViewController as? UINavigationController {
                nav.pushViewController(messageVC, animated: true)
            } else {
                self?.selectedViewController?.present(messageVC, animated: true)
            }
        }
        
        topBar.onProfileTapped = { [weak self] in
            self?.showProfileSideBar()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let nav = selectedViewController as? UINavigationController,
           nav.topViewController is PostViewController {
            topBar.isHidden = true
        } else {
            topBar.isHidden = false
        }
    }
    
    func showProfileSideBar() {
        let sideBarVC = ProfileSideBarViewController(nibName: "ProfileSideBarViewController", bundle: nil)
        addChild(sideBarVC)
        
        let width: CGFloat = self.view.frame.width * 0.8
        
        // Arkaya tam ekran bir overlayView koy
        let overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.tag = 999  // sonradan kaldırmak için tag ver
        self.view.addSubview(overlayView)
        
        // Dışarı tıklanınca sidebar kapansın
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSidebar))
        overlayView.addGestureRecognizer(tapGesture)
        
        //  Sidebar'ı overlay üzerine koy
        sideBarVC.view.frame = CGRect(x: -width, y: 0, width: width, height: self.view.frame.height)
        overlayView.addSubview(sideBarVC.view)
        
        sideBarVC.didMove(toParent: self)
        
        UIView.animate(withDuration: 0.3) {
            sideBarVC.view.frame.origin.x = 0
        }
    }
    
    @objc func hideSidebar() {
        if let overlayView = self.view.viewWithTag(999) {
            UIView.animate(withDuration: 0.3, animations: {
                if let sidebar = overlayView.subviews.first {
                    sidebar.frame.origin.x = -sidebar.frame.width
                }
            }) { _ in
                overlayView.removeFromSuperview()
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            // Seçimi engelle: kullanıcı aslında bu tab'a geçmesin
            self.selectedIndex = previousIndex // önceki tab'da kal

            // Post ekranını aç
            let postVC = PostViewController(nibName: "PostView", bundle: nil)
            postVC.modalPresentationStyle = .fullScreen
            present(postVC, animated: true)
        } else {
            previousIndex = item.tag // diğer tablar için index’i güncelle
        }
    }

}
