//
//  CustomHeaderView.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 9.05.2025.
//

import UIKit

// ViewController'ı haber vermek için
protocol CustomHeaderViewDelegate: AnyObject {
    func didTapAddButton(in headerView: CustomHeaderView, for section: Int)
    func didTapEditButton(in headerView: CustomHeaderView, for section: Int)
}

// CustomHeaderView.swift

class CustomHeaderView: UITableViewHeaderFooterView {
    weak var delegate: CustomHeaderViewDelegate?
    
    let headerLabel = UILabel()
    let addButton = UIButton()
    let editButton = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.backgroundColor = .appBackground
        
        // Header Label
        headerLabel.textColor = .white
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerLabel)
        
        // Add Button (+)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .gray
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        contentView.addSubview(addButton)
        
        // Edit Button (kalem)
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = .gray
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        contentView.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 24),
            editButton.heightAnchor.constraint(equalToConstant: 24),
            
            addButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 24),
            addButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func addButtonTapped() {
        delegate?.didTapAddButton(in: self, for: tag)
    }
    
    @objc private func editButtonTapped() {
        delegate?.didTapEditButton(in: self, for: tag)
    }
}
