//
//  MeMeViewController.swift
//  MemeMe
//
//  Created by Ali Şahbaz on 12.12.2020.
//

import UIKit

class MeMeViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
//    var topTextFieldAlreadyEdited :Bool = true
//    var bottomTextFieldAlreadyEdited :Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldAttributes(upperTextField)
        setTextFieldAttributes(bottomTextField)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeKeyboardMoves()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        let memedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { (_, completed, _, _) in
            if (completed) {
                self.save()
            }
        }
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        upperTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        image.image = nil
    }
    
    @IBAction func pickImageClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCameraClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    
//  MARK: HELPER FUNCTIONS
    func setupUI(){
        image.contentMode = .scaleAspectFit
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) == true
    }
    
    func hideToolBars(_ hidden : Bool){
        topToolBar.isHidden = hidden
        bottomToolBar.isHidden = hidden
    }
    
    func setTextFieldAttributes(_ textfield: UITextField){
        let textAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth : -3
        ]
        textfield.defaultTextAttributes = textAttributes
        textfield.contentVerticalAlignment = .center
        textfield.textAlignment = .center
        textfield.delegate = self
    }
    
    func save() {
        _ = Meme(topText: upperTextField.text!, bottomText: bottomTextField.text!, originalImage: image.image!, memedImage:  generateMemedImage())
        //TODO: It will use next meme project
    }
    
    func generateMemedImage() -> UIImage {
        hideToolBars(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideToolBars(false)
        return memedImage
    }
}

// MARK: IMAGE PICKER DELEGATES
extension MeMeViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            image.image = img
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: TEXTFIELD DELEGATES
extension MeMeViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: KEYBOOARD VIEW DELEGATES UI UPDATES
extension MeMeViewController {
    func subscribeKeyboardMoves(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(_ notification : Notification){
        if bottomTextField.isFirstResponder {
            bottomConstraint.constant -= getKeyboardHeight(notification)
            topConstraint.constant -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification : Notification){
        bottomConstraint.constant = 0
        topConstraint.constant = 0
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let info = notification.userInfo
        let keyboard = info![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboard.cgRectValue.height
    }

}

