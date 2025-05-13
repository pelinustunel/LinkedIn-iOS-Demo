//
//  InvitationAcceptCollectionView.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 8.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire


class InvitationAcceptTableView: UITableViewCell {
    
    @IBOutlet weak var innerTableView: UITableView!
    
    static let identifier = "InvitationAcceptTableView"
    
    let disposeBag = DisposeBag()
    private let viewModel = NetworkListViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewModel.fetchNetworkLists()
        setupTableView()
        bindTableView()
  
        
    }
    
    private func setupTableView() {
        innerTableView.isScrollEnabled = false // önemli! scrolldan dış tableView sorumlu olacak
        innerTableView.separatorStyle = .none
        
        innerTableView.register(UINib(nibName: InvitationAcceptTableCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: InvitationAcceptTableCell.cellIdentifier)
        
        
    }
    
    
    
    func bindTableView() {
        
        viewModel.networkLists
            .bind(to: innerTableView.rx.items(cellIdentifier: "InvitationAcceptTableCell", cellType: InvitationAcceptTableCell.self)) { index, connections, cell in
                
                cell.userNameLabel.text = connections.name
                cell.jobLabel.text = connections.job
                cell.connectionLabel.text = connections.mutual_connection
                cell.dateLabel.text = connections.date
                
                // Profil resmi URL'den yüklensin
                if let profileURLString = connections.profile_image,
                   let profileURL = URL(string: profileURLString) {
                    URLSession.shared.dataTask(with: profileURL) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.profileImageView.image = image
                            }
                        }
                    }.resume()
                } else {
                    cell.profileImageView.image = UIImage(named: "profile") // fallback
                }
                
                
            }
            .disposed(by: disposeBag)
        
    }
    
  }
    
    

