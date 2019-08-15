//
//  ViewController.swift
//  Challenge4
//
//  Created by Adrimi on 15/08/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takePhoto))
        
        load()
        
    }
    
    @objc func takePhoto() {
        
    }
    
    func load() {
        let defaults = UserDefaults.standard
    }
    
    func save() {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)
        
        // getters
        let photo = photos[indexPath.row]
        let path = getDocumentDirectory().appendingPathComponent(photo.image)
        
        // setters
        cell.textLabel?.text = photo.name
        // cell.detailTextLabel?.text = data zrobienia !!!
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        cell.imageView?.layer.borderWidth = 2
        cell.imageView?.layer.cornerRadius = 3
        
        return cell
    }
    

    func getDocumentDirectory() -> URL {
        // default.urls asks for /documents directory, relative to the user's home directory.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

