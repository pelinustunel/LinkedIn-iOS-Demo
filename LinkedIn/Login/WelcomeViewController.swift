//
//  ViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 29.11.2024.
//

import UIKit

struct Page {
    let animationName: String
    let description: String
}

class WelcomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    var timer: Timer?
    var currentPage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.accessibilityIdentifier = "WelcomeSignIn"
        
        self.pageControl.numberOfPages = self.pages.count
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changePage), userInfo: nil, repeats: true)
        collectionView.register(UINib(nibName: PageCellViewController.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PageCellViewController.cellIdentifier)
        
        
    }
    
    // Animasyon ve başlık verileri
    let pages: [Page] = [Page(animationName: "animation1", description: "Bir sonraki işinizi bulun ve işe alının."),
                         Page(animationName: "animation2", description: "Hareket halindeyken ağınızı oluşturun."),
                         Page(animationName: "animation3", description: "Kariyeriniz için seçilen içeriklerle öne geçin.")]
    
    
    
    // Timer'ın çalıştıracağı method
    @objc func changePage() {
        currentPage = (currentPage + 1) % pages.count
        
        // Koleksiyon görünümünü kaydır
        collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally, animated: true)
        
        // UIPageControl'ü güncelle
        pageControl.currentPage = currentPage
    }
    
    @IBAction func pageChanged(_ sender: Any) {
        let pc = sender as! UIPageControl
        
        // scrolling the collectionView to the selected page
        collectionView.scrollToItem(at: IndexPath(item: pc.currentPage, section: 0),
                                    at: .centeredHorizontally, animated: true)
    }
    
    
    // MARK:- collectionView dataSource & collectionView FlowLayout delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCellViewController.cellIdentifier, for: indexPath) as! PageCellViewController
        cell.configureCell(page: pages[indexPath.item])
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
        currentPage = pageIndex
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    
    @IBAction func signUpClick(_ sender: Any) {
        let signUpVC = SignUpNameViewController(nibName: "SignUpName", bundle: nil)
        
        signUpVC.modalPresentationStyle = .overFullScreen
        
        // Başlangıç pozisyonu (Ekranın dışında)
        signUpVC.view.frame.origin.y = self.view.frame.size.height
        
        // Görünümü ekrana getir
        self.present(signUpVC, animated: false) {
            // Animasyon ile yukarı kaydır
            UIView.animate(withDuration: 100, delay: 0, options: .curveEaseInOut, animations: {
                signUpVC.view.frame.origin.y = 0
            }, completion: nil)
        }
    }
    
    @IBAction func signInClick(_ sender: Any) {
        
        
        let signInVC = SignInViewController(nibName: "SignInView", bundle: nil)
        
        signInVC.modalPresentationStyle = .overFullScreen
        
        // Başlangıç pozisyonu (Ekranın dışında)
        signInVC.view.frame.origin.y = self.view.frame.size.height
        
        // Görünümü ekrana getir
        self.present(signInVC, animated: false) {
            // Animasyon ile yukarı kaydır
            UIView.animate(withDuration: 100, delay: 0, options: .curveEaseInOut, animations: {
                signInVC.view.frame.origin.y = 0
            }, completion: nil)
        }
    }
    
}

