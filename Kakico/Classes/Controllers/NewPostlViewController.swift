import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class NewPostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

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

    @IBAction func save(sender: UIBarButtonItem) {
        post(contentField.text, picture: nil)
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        checkValidMicropostContent()
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

    // MARK: -
    func post(content: String, picture: UIImage?) {
        contentField.resignFirstResponder()
        let params = [
            "content": content,
            "picture": ""
        ]
        SVProgressHUD.showWithMaskType(.Black)
        Alamofire.request(Router.PostMicropost(params: params)).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            println(json["status"])
            if json["status"] == 200 {
                SVProgressHUD.showSuccessWithStatus("Post")
                let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FeedNavigationController") as! UIViewController
                self.presentViewController(targetViewController, animated: true, completion: nil)
            } else{
                SVProgressHUD.showErrorWithStatus(json["messages"]["notice"].array!.first?.stringValue, maskType: .Black)
            }
        }
    }
}
