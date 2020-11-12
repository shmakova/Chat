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
    @IBOutlet weak var gcdSaveButton: UIButton!
    @IBOutlet weak var operationSaveButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var editProfileButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var editInfoTextView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var model: ProfileModelProtocol!
    
    private var currentProfile: ProfileData = .empty {
        didSet {
            log("Profile data updated with \(String(describing: currentProfile))")
            nameLabel.text = currentProfile.name.isEmpty ? "No name" : currentProfile.name
            editNameTextField.text = currentProfile.name
            infoLabel.text = currentProfile.info.isEmpty ? "No info" : currentProfile.info
            editInfoTextView.text = currentProfile.info
            avatarInitialsView.text = currentProfile.initials ?? "-"
            showAvatar(image: currentProfile.avatar)
        }
    }
    
    private var unsavedProfile: ProfileData {
        ProfileData(
            name: editNameTextField.text ?? "",
            info: editInfoTextView.text ?? "",
            avatar: avatarImageView.image
        )
    }
    
    private var lastProfileDataManagerMethod: ProfileDataManagerMethod?
    
    private var wasProfileEdited: Bool {
        return currentProfile.name != editNameTextField.text
            || currentProfile.info != editInfoTextView.text
            || currentProfile.avatar != avatarImageView.image
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Views are not loaded yet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideAllViews()
        logViewControllerState()
        log("Save button frame \(gcdSaveButton.frame)")
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        gcdSaveButton.layer.cornerRadius = 14
        operationSaveButton.layer.cornerRadius = 14
        let borderGray = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        editInfoTextView.layer.borderColor = borderGray.cgColor
        editInfoTextView.layer.borderWidth = 1
        editInfoTextView.layer.cornerRadius = 5
        editInfoTextView.delegate = self
        editNameTextField.delegate = self
        applyTheme(model.currentTheme)
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        model.loadProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logViewControllerState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logViewControllerState()
        // The view adjusted the position of its subviews, so frames were updated.
        log("Save button frame \(gcdSaveButton.frame)")
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
    
    @IBAction func onCloseTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEditProfileTap(_ sender: Any) {
        enableSaveButtons(isEnabled: false)
        showViews(isEdit: true)
    }
    
    @IBAction func onEditAvatarTap(_ sender: Any) {
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
    
    @IBAction func onNameTextFieldChanged(_ sender: Any) {
        enableSaveButtons(isEnabled: wasProfileEdited)
    }
    
    @IBAction func onGCDSaveTap(_ sender: Any) {
        saveProfile(method: .gcd)
    }
    
    @IBAction func onOperationSaveTap(_ sender: Any) {
        saveProfile(method: .operation)
    }
    
    private func saveProfile(method: ProfileDataManagerMethod) {
        lastProfileDataManagerMethod = method
        onStartLoading()
        model.saveProfile(
            method: method,
            currentProfile: currentProfile,
            unsavedProfile: unsavedProfile
        )
    }
    
    private func makeSuccessSaveProfileAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Success",
            message: "Profile was saved",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    private func makeErrorSaveProfileAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Error",
            message: "Failed to save data",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "Retry",
                style: .default,
                handler: { [weak self] _ in
                    guard let self = self, let method = self.lastProfileDataManagerMethod else {
                        return
                    }
                    self.saveProfile(method: method)
                }
            )
        )
        return alert
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
    
    private func onStartLoading() {
        enableSaveButtons(isEnabled: false)
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func showAvatar(image: UIImage?) {
        guard let image = image else {
            avatarInitialsView.isHidden = false
            return
        }
        avatarInitialsView.isHidden = true
        avatarImageView.image = image
    }
    
    private func hideAllViews() {
        avatarImageView.isHidden = true
        avatarInitialsView.isHidden = true
        avatarEditButton.isHidden = true
        gcdSaveButton.isHidden = true
        operationSaveButton.isHidden = true
        nameLabel.isHidden = true
        editNameTextField.isHidden = true
        infoLabel.isHidden = true
        editInfoTextView.isHidden = true
        activityIndicatorView.isHidden = true
        editProfileButton.isEnabled = false
    }
    
    private func showViews(isEdit: Bool) {
        editProfileButton.isEnabled = true
        avatarImageView.isHidden = false
        avatarEditButton.isHidden = !isEdit
        gcdSaveButton.isHidden = !isEdit
        operationSaveButton.isHidden = !isEdit
        editNameTextField.isHidden = !isEdit
        nameLabel.isHidden = isEdit
        editInfoTextView.isHidden = !isEdit
        infoLabel.isHidden = isEdit
    }
    
    private func enableSaveButtons(isEnabled: Bool) {
        gcdSaveButton.isEnabled = isEnabled
        operationSaveButton.isEnabled = isEnabled
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension ProfileViewController: ProfileViewControllerDelegate {
    func handleLoadProfileResult(_ result: Result<ProfileData, Error>) {
        assert(Thread.isMainThread)
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        showViews(isEdit: false)
        switch result {
        case let .success(profile):
            currentProfile = profile
        case let .failure(error):
            log("Data loading failed with \(error)")
        }
    }
    
    func handleSaveProfileResult(
        _ result: Result<Void, Error>,
        profile: ProfileData
    ) {
        assert(Thread.isMainThread)
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        enableSaveButtons(isEnabled: true)
        switch result {
        case .success:
            showViews(isEdit: false)
            currentProfile = profile
            present(makeSuccessSaveProfileAlert(), animated: true, completion: nil)
        case let .failure(error):
            log("Failed to save data with \(error)")
            showViews(isEdit: true)
            present(makeErrorSaveProfileAlert(), animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.showAvatar(image: info[.originalImage] as? UIImage)
            self.enableSaveButtons(isEnabled: self.wasProfileEdited)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: ThemeableView {
    func applyTheme(_ theme: Theme) {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
        view.backgroundColor = theme.colors.backgroundColor
        navigationBar?.barTintColor = theme.colors.navigationBarColor
        navigationBar?.titleTextAttributes = [.foregroundColor: theme.colors.primaryTextColor]
        nameLabel.textColor = theme.colors.primaryTextColor
        infoLabel.textColor = theme.colors.primaryTextColor
        gcdSaveButton.backgroundColor = theme.colors.profileSaveButtonBackgroundColor
        operationSaveButton.backgroundColor = theme.colors.profileSaveButtonBackgroundColor
        activityIndicatorView.style = theme.activityIndicatorStyle
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        enableSaveButtons(isEnabled: wasProfileEdited)
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enableSaveButtons(isEnabled: wasProfileEdited)
        return textField.resignFirstResponder()
    }
}

private func logViewControllerState(function: String = #function) {
    log(function)
}
