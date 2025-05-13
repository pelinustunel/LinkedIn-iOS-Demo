//
//  NetworkViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 7.04.2025.
//

import UIKit

class NetworkViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor(hex: "#1C1C1E")
        
        tableView.register(UINib(nibName: "InvitationTableCell", bundle: nil), forCellReuseIdentifier: "InvitationTableCell")
        tableView.register(UINib(nibName: InvitationAcceptTableView.identifier, bundle: nil), forCellReuseIdentifier: InvitationAcceptTableView.identifier)
        tableView.register(UINib(nibName: "ManageNetworkTableCell", bundle: nil), forCellReuseIdentifier: "ManageNetworkTableCell")
        
        
        tableView.separatorStyle = .none // opsiyonel, çizgileri kaldırmak istersen
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationTableCell", for: indexPath) as! InvitationTableCell
            
            cell.onDetailClick = { [weak self] in
                let networkListVC = NetworkListView(nibName: "NetworkListView", bundle: nil)
                self?.navigationController?.pushViewController(networkListVC, animated: true)
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationAcceptTableView", for: indexPath) as! InvitationAcceptTableView
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManageNetworkTableCell", for: indexPath) as! ManageNetworkTableCell
            return cell
            
        }
        
    }
    
    // Header boşluğu azalt
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4 // ya da 0.1
    }
    
    // Footer boşluğu azalt
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4 // ya da 0.1
    }
    
    // Header görünmesin
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // Footer görünmesin
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 50
        }else if indexPath.section == 1 {
            return 250
        }else{
            return 50
        }
        
    }
    
    
}
