import UIKit

class MicropostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    var micropost = Micropost?()
    
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        contentField.delegate = self
        checkValidMicropostContent()
    }
    
    // MARK: - Actions
    @IBAction func unFocusTextField(sender: AnyObject) {
        contentField.resignFirstResponder()
    }
    
    @IBAction func openPhotoLibrary(sender: UIButton) {
        contentField.resignFirstResponder()
        
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
            let content = contentField.text ?? ""
            let picture = pictureImageView.image
            
            micropost = Micropost(content: content, picture: picture)
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
        checkValidMicropostContent()
        navigationItem.title = textView.text
    }
    
    func checkValidMicropostContent() {
        let text = contentField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        pictureImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
}
