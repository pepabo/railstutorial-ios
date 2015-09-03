import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class MicropostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var microposts = MicropostDataManager()
    var micropost: Micropost?
    
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
            post(contentField.text, picture: nil)
        }
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
        let params = [
            "content": content,
            "picture": ""
        ]
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
        Alamofire.request(Router.PostMicropost(params: params)).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            println(json["status"])
            if json["status"] == 200 {
                SVProgressHUD.showSuccessWithStatus("Post")
            } else{
                SVProgressHUD.showErrorWithStatus("", maskType: .Black)
            }
        }
    }
}
