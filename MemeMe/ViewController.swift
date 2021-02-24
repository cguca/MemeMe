//
//  ViewController.swift
//  MemeMe
//
//  Created by Cary Guca on 2/18/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var memedImage: UIImage?
    
    let memeMeTextDelegate = MemeMeTextDelegate()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        //NSAttributedString.Key.strokeColor: UIColor.blue,
       // NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
       // NSAttributedString.Key.strokeWidth:  2.0
    ]
    
    struct Meme {
        var topText : String?
        var bottomText : String?
        var originalImage : UIImage?
        var memedImage : UIImage?
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.textColor = .white
        topTextField.delegate = self.memeMeTextDelegate
        topTextField.isEnabled = false
    
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
        bottomTextField.textColor = .white
        bottomTextField.delegate = self.memeMeTextDelegate
        bottomTextField.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imagePickerView.image != nil
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        shareButton.isEnabled = true
        topTextField.isEnabled = true
        bottomTextField.isEnabled = true
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
        shareButton.isEnabled = true
        topTextField.isEnabled = true
        bottomTextField.isEnabled = true
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }

    @IBAction func shareMeme(_ sender: Any) {
        let items = [generateMemedImage()]
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(avc, animated: true)
        
        avc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                self.save()
            }
        }
    }

    
    func save() {
            // Create the meme
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
// developer.apple.com/documentation/foundation/notification/1779652-userinfo
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if notification.object is UITextField? {
                // work with the field editor and posting object
        }
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardHideShow(_ notification:Notification) {

        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
   
}

