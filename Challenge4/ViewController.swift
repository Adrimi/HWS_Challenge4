//
//  ViewController.swift
//  Challenge4
//
//  Created by Adrimi on 15/08/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Main View Data
        title = "Photo Gallery"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takePhoto))
        
        setupGestures()
        
        // Load in the background
        performSelector(inBackground: #selector(load), with: nil)
        
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.6
        longPress.delegate = self
        
        tableView.addGestureRecognizer(tap)
        tableView.addGestureRecognizer(longPress)
    }
    
    @objc func takePhoto() {
        // instantiate picker
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // extract image from dictionary
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 1.0) {
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Photo(name: "Unknown", image: imageName, date: Date())
        photos.append(photo)
        
        tableView.reloadData()
        dismiss(animated: true)
        renamePhoto(photo)
        save()
    }
    
    @objc func load() {
        let defaults = UserDefaults.standard
        if let savedPhotos = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
            } catch {
                print("Failed to load photos")
            }
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        } else {
            print("Failed to save photos")
        }
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
        cell.detailTextLabel?.text = photo.formattedDate()
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        cell.imageView?.layer.borderWidth = 1
        
        return cell
    }
    
    @objc func handleLongPress(_ press: UILongPressGestureRecognizer) {
        if press.state == .began  {
            if let indexPath = getIndexPath(press) {
                
                let ac = UIAlertController(title: "What you want to do?", message: nil, preferredStyle: .alert)
                
                ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
                    guard let photo = self?.photos[indexPath.row] else { return }
                    self?.renamePhoto(photo)
                })
                
                ac.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
                    guard let photo = self?.photos[indexPath.row] else { return }
                    self?.deletePhoto(photo, at: indexPath)
                })
                
                present(ac, animated: true)
            }
        }
    }
    
    func renamePhoto(_ photo: Photo) {
        let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
            guard var newName = ac?.textFields?[0].text else { return }
            if newName == "" { newName = "Unknown" }
            photo.name = newName
            self?.save()
            self?.tableView.reloadData()
        })
    
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func deletePhoto(_ photo: Photo, at index: IndexPath) {
        let ac = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.photos.remove(at: index.row)
            self?.tableView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        if let indexPath = getIndexPath(tap), let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
                vc.selectedPhoto = photos[indexPath.row]
                vc.indexOfSelectedImage = indexPath.row + 1
                vc.totalImagesCount = photos.count
                navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getIndexPath(_ gesture: UIGestureRecognizer) -> IndexPath? {
        let touchPoint = gesture.location(in: tableView)
        return tableView.indexPathForRow(at: touchPoint)
    }

    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

