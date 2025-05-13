//
//  NetworkListViewCell.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 9.04.2025.
//

protocol NetworkListViewCellDelegate: AnyObject {
    func didTapAccept(connection: ConnectionModel)
    func didTapReject(connection: ConnectionModel)
}


import UIKit

class NetworkListViewCell : UITableViewCell {
    
    static let cellIdentifier = "NetworkListViewCell"
    
    weak var delegate: NetworkListViewCellDelegate?
    
    var connection: ConnectionModel?
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fillCell(model: ConnectionModel, image: UIImage) {
        userNameLabel.text = model.name
        jobLabel.text = model.job
        connectionLabel.text = model.mutual_connection
        dateLabel.text = model.date
        profileImageView.image = image
        connection = model
    }
    
    
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        guard let connection = connection else { return }
        delegate?.didTapAccept(connection: connection)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        guard let connection = connection else { return }
        delegate?.didTapReject(connection: connection)
        
    }
    
}
