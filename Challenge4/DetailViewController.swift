//
//  DetailViewController.swift
//  Challenge4
//
//  Created by Adrimi on 15/08/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedPhoto: Photo?
    var indexOfSelectedImage: Int?
    var totalImagesCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedPhoto = selectedPhoto else { return }
        
        if let index = indexOfSelectedImage, let total = totalImagesCount {
            title = "\(index)\\\(total)  -  \(selectedPhoto.date)"
        }
        else {
            #if DEBUG
            print("DEBUG - data not loaded")
            #endif
        }
        
        navigationItem.largeTitleDisplayMode = .never
        let path =  getDocumentDirectory().appendingPathComponent(selectedPhoto.image)
        imageView.image = UIImage(contentsOfFile: path.path)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
