//
//  ImagePickerViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import UIKit

class ImagePickerViewController: UIViewController {
    
    private let collectionView: UICollectionView
    private let activityIndicator: UIActivityIndicatorView
    
    private let dataModel: ImagePickerDataModelProtocol
    
    weak var delegate: ImagePickerDelegate?
    
    init(dataModel: ImagePickerDataModelProtocol) {
        let cellSize = (UIScreen.main.bounds.width - 22) / 3.0
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: cellSize,
                                               height: cellSize)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 5,
                                                         left: 5,
                                                         bottom: 5,
                                                         right: 5)
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout.minimumInteritemSpacing = 5
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionViewLayout)
        activityIndicator = UIActivityIndicatorView()
        
        self.dataModel = dataModel
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.titleView = activityIndicator
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCloseButton))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureViews()
    }
    
    private func configureViews() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImagePickerCell.self,
                                forCellWithReuseIdentifier: ImagePickerCell.identifier)
        
        activityIndicator.hidesWhenStopped = true
    }
    
    private func fetchData() {
        dataModel.fetchImagesURL()
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
}

extension ImagePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataModel.getImages().count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCell.identifier,
                                                            for: indexPath) as? ImagePickerCell else { fatalError("ImagePickerCell not inited") }
        
        let imageURL = self.dataModel.getImages()[indexPath.row].previewURL
        self.dataModel.fetchImage(imageUrl: imageURL) { image in
            DispatchQueue.main.async {
                cell.configure(image: image)
                cell.layoutIfNeeded()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let imageURL = self.dataModel.getImages()[indexPath.row].webformatURL
        self.dataModel.fetchImage(imageUrl: imageURL) { image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.delegate?.didSelect(image: image)
                self.didTapCloseButton()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == dataModel.getImages().count - 1 {
            dataModel.fetchImagesURL()
        }
    }
}

extension ImagePickerViewController: ImagePickerDataModelDelegate {
    func loadStarted() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func loadComplited() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
