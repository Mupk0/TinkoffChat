//
//  ImagePickerCell.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import UIKit

class ImagePickerCell: UICollectionViewCell {
    
    static let identifier = "ImagePickerCell"
    
    private let imageView = UIImageView()
    public let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        addSubview(imageView)
        imageView.addSubview(activityIndicator)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: imageView.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        
        imageView.image = #imageLiteral(resourceName: "placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        activityIndicator.hidesWhenStopped = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = #imageLiteral(resourceName: "placeholder")
    }

    func configure(image: UIImage?) {
        imageView.image = image
    }
}
