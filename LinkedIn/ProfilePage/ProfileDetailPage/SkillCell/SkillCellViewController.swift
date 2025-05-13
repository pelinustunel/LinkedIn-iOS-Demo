//
//  SkillCellViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 13.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

class SkillCellViewController : UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var skillTableView: UITableView!
    
    let disposeBag = DisposeBag()
    var skills: [SkillModel] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        skillTableView.dataSource = self
        skillTableView.delegate = self
        
        skillTableView.register(UINib(nibName: "SkillRowCellView", bundle: nil), forCellReuseIdentifier: "SkillRowCellViewController")
    }
    
    func configure(with skills: [SkillModel]) {
        self.skills = skills
        skillTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkillRowCellViewController", for: indexPath) as! SkillRowCellViewController
        let skill = skills[indexPath.row]
        
        cell.skillNameLabel.text = skill.name
        return cell
        
    }
    
}
