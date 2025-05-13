//
//  HomeViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 7.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class HomeViewController : UIViewController{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    let posts = BehaviorRelay<[PostModel]>(value: [])
    
    override func viewDidLoad() {
        
        
        let nib = UINib(nibName: "HomeViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeViewCell")
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hex: "#1C1C1E")
        
        // Dinleme
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPosts), name: .postAdded, object: nil)
        
        tableView.reloadData()
        
        bindTableView()
        bindErrorHandling()
        
        viewModel.fetchPosts()
        
        
    }
    
    @objc private func reloadPosts() {
        viewModel.fetchPosts()
    }

    
    private func bindTableView() {
        viewModel.posts
            .bind(to: tableView.rx.items(cellIdentifier: "HomeViewCell", cellType: HomeViewCell.self)) { index, post, cell in
                
                cell.UserNameTextField.text = post.user_id
                cell.JobLabel.text = post.job_text
                cell.dateLabel.text = post.timestamp
                cell.mentionLabel.text = post.content
                cell.interactionNumbers.text = "\(post.likes)"
                
                // Profil resmi
                if let profileURLString = post.profile_image_url,
                   let profileURL = URL(string: profileURLString) {
                    URLSession.shared.dataTask(with: profileURL) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.profileImage.image = image
                            }
                        }
                    }.resume()
                } else {
                    cell.profileImage.image = UIImage(named: "profile")
                }
                
                // Post görseli
                if let postURLString = post.image_url,
                   let postURL = URL(string: postURLString) {
                    URLSession.shared.dataTask(with: postURL) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.postImageView.image = image
                            }
                        }
                    }.resume()
                } else {
                    cell.postImageView.image = nil
                }
            }
            .disposed(by: disposeBag)
    }
    private func bindErrorHandling() {
        viewModel.errorMessage
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
}

