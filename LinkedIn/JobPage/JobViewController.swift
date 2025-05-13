//
//  JobView.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 10.04.2025.
//


import UIKit
import RxSwift
import RxCocoa
import Alamofire


class JobViewController: UIViewController{
    
    @IBOutlet weak var jobTableView: UITableView!
    
    let disposeBag = DisposeBag()
    private let viewModel = JobViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTableView()
        bindTableView()
        bindErrorHandling()
        
        viewModel.fetchJobs()
    }
    
    private func setupTableView() {
        jobTableView.isUserInteractionEnabled = true
        let nib = UINib(nibName: "JobTableViewCell", bundle: nil)
        jobTableView.register(nib, forCellReuseIdentifier: "JobTableViewCell")
        jobTableView.separatorStyle = .none
    }
    
    private func bindTableView() {
        viewModel.jobs
            .bind(to: jobTableView.rx.items(cellIdentifier: "JobTableViewCell", cellType: JobTableViewCell.self)) { index, job, cell in
                
                cell.jobNameLabel.text = job.title
                cell.jobCompanyNameLabel.text = job.company
                cell.jobCountryNameLabel.text = job.location
                
                if let profileURLString = job.company_logo,
                   let profileURL = URL(string: profileURLString) {
                    URLSession.shared.dataTask(with: profileURL) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.jobImageView.image = image
                            }
                        }
                    }.resume()
                } else {
                    cell.jobImageView.image = UIImage(named: "profile")
                }
            }
            .disposed(by: disposeBag)
        
        jobTableView.rx.modelSelected(JobModel.self)
            .subscribe(onNext: { [weak self] selectedJob in
                guard let self = self else { return }
                let jobDetailVC = JobDetailViewController(nibName: "JobDetailViewController", bundle: nil)
                jobDetailVC.jobModel = selectedJob
                
                if let sheet = jobDetailVC.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 20
                }
                self.present(jobDetailVC, animated: true)
            })
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
