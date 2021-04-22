//
//  ImagePickerCollectionViewFlowLayout.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import UIKit

class ImagePickerCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let columnsCount: CGFloat = 3
        let itemOffset: CGFloat = 5
        let itemSizeExtent = (collectionView.bounds.width - itemOffset * (columnsCount + 1)) / columnsCount
        
        sectionInset = UIEdgeInsets(top: itemOffset, left: itemOffset, bottom: itemOffset, right: itemOffset)
        itemSize = CGSize(width: itemSizeExtent, height: itemSizeExtent)
        minimumLineSpacing = itemOffset
        minimumInteritemSpacing = itemOffset
    }
}
