import UIKit

class MicropostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var postField: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    var micropost = Micropost?()
    
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        postField.delegate = self
        checkValidMicropostName()
    }
    
    // MARK: - Actions
    @IBAction func unFocusTextField(sender: AnyObject) {
        postField.resignFirstResponder()
    }
    
    @IBAction func openPhotoLibrary(sender: UIButton) {
        postField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = postField.text ?? ""
            let photo = photoImageView.image
            
            micropost = Micropost(name: name, photo: photo)
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    func textViewDidBeginEditing(textView: UITextView) {
        saveButton.enabled = false
    }
    
    func textViewDidChange(textView: UITextView) {
        checkValidMicropostName()
        navigationItem.title = textView.text
    }
    
    func checkValidMicropostName() {
        let text = postField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
}
