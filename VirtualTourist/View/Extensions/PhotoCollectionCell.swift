//
//  PhotoCollectionCell.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/16/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let imageLoading = CGFloat(0.5)
    
    func startLoading(){
        activityIndicator.startAnimating()
        imageView.alpha = imageLoading
    }
    
    func stopLoading(){
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        imageView.alpha = 1
    }
}
