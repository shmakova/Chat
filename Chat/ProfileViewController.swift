//
//  ProfileViewController.swift
//  Chat
//
//  Created by Anastasia Shmakova on 12.09.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarInitialsView: UILabel!
    @IBOutlet weak var avatarEditButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Views are not loaded yet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logViewControllerState()
        log("Save button frame \(saveButton.frame)")
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        saveButton.layer.cornerRadius = 14
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logViewControllerState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logViewControllerState()
        // The view adjusted the position of its subviews, so frames were updated.
        log("Save button frame \(saveButton.frame)")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logViewControllerState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logViewControllerState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logViewControllerState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logViewControllerState()
    }
    
    @IBAction func onEditTap(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Choose an action",
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.addAction(
            UIAlertAction(title: "Pick a photo from gallery", style: .default, handler: pickPhotoFromGallery)
        )
        alertController.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: takePhoto))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func pickPhotoFromGallery(action: UIAlertAction) {
        pickImage(from: .photoLibrary)
    }
    
    private func takePhoto(action: UIAlertAction) {
        pickImage(from: .camera)
    }
    
    private func pickImage(from sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            let alert = UIAlertController(
                title: "Error",
                message: "This action is not supported on this device",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
            
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        dismiss(animated: true) { [weak self] in
            guard let image = info[.originalImage] as? UIImage else {
                self?.avatarInitialsView.isHidden = false
                return
            }
            self?.avatarInitialsView.isHidden = true
            self?.avatarImageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

private func logViewControllerState(function: String = #function) {
    log(function)
}
