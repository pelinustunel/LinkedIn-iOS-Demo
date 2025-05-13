//
//  ActivityCellViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 13.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class ActivityCellViewController : UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var createAPostButton: UIButton!
    @IBOutlet weak var organizeProfileButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var activities: [ActivityModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ActivityRowCellView", bundle: nil), forCellReuseIdentifier: "ActivityRowCellView")
        
    }
    
    func configure(with activities: [ActivityModel]) {
        self.activities = activities
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityRowCellView", for: indexPath) as! ActivityRowCellViewController
        let activity = activities[indexPath.row]
        
        cell.commentLabel.text = activity.title
        cell.commentDetailLabel.text = activity.description
        return cell
    }
    
}
