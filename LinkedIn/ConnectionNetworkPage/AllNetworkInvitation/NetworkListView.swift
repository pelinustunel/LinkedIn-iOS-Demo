//
//  NetworkListView.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 9.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire


class NetworkListView : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let disposeBag = DisposeBag()
    private let viewModel = NetworkListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        viewModel.fetchNetworkLists()
        bindTableView()
        bindErrorHandling()
        
        
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "NetworkListViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NetworkListViewCell")
        
    }
    
    
    func bindTableView() {
        viewModel.networkLists
            .bind(to: tableView.rx.items(cellIdentifier: "NetworkListViewCell", cellType: NetworkListViewCell.self)) { [weak self] index, connection, cell in
                
                // Önce default resimle doldur
                cell.fillCell(model: connection, image: UIImage(named: "profile")!)
                cell.delegate = self
                
                // Profil resmi yüklemesi (güncel resimle değiştir)
                if let profileURLString = connection.profile_image,
                   let profileURL = URL(string: profileURLString) {
                    URLSession.shared.dataTask(with: profileURL) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                // Hücre görünürse güncelle
                                cell.fillCell(model: connection, image: image)
                            }
                        }
                    }.resume()
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

extension NetworkListView: NetworkListViewCellDelegate {
    func didTapAccept(connection: ConnectionModel) {
        viewModel.addConnection(connection: connection)
    }
    
    func didTapReject(connection: ConnectionModel) {
        viewModel.deleteConnection(name: connection.name ?? "")
    }
}
