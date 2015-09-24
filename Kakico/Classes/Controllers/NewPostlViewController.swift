import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class NewPostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        contentField.delegate = self
        setPlaceHolder(contentField)
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

    @IBAction func deletePicture(sender: AnyObject) {
        if self.pictureImageView.image != nil {
            showDeletingAlert()
        }
    }

    @IBAction func save(sender: UIBarButtonItem) {
        post(contentField.text, picture: pictureImageView.image)
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        contentField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - UITextField Delegate
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    func textViewDidBeginEditing(textView: UITextView) {
        setPlaceHolder(textView)
    }

    func textViewDidChange(textView: UITextView) {
        checkValidMicropostContent()
    }

    func textViewDidEndEditing(textView: UITextView) {
        setPlaceHolder(textView)
    }

    // MARK: - UIImagePickerController Delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        pictureImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - API request methods
    func post(content: String, picture: UIImage?) {
        SVProgressHUD.showWithMaskType(.Black)
        contentField.resignFirstResponder()
        Alamofire.upload(
            Router.PostMicropost(),
            multipartFormData: { (multipartFormData) in
                multipartFormData.appendBodyPart(data: content.dataUsingEncoding(NSUTF8StringEncoding)!, name: "content")

                if picture != nil {
                    let data = NSData(data: UIImagePNGRepresentation(picture))
                    let filePath = NSTemporaryDirectory() + "/picture_temp.png"
                    data.writeToFile(filePath, atomically: true)
                    multipartFormData.appendBodyPart(fileURL: NSURL(fileURLWithPath: filePath)!, name: "picture", fileName: "picture.png", mimeType: "image/png")
                }
            },
            encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { _, _, data, error in
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
                case .Failure(let encodingError):
                    println(encodingError)
                }
        })
    }

    // MARK: - Helpers
    private func setPlaceHolder(textView: UITextView) {
        if textView.hasText() {
            textView.placeholder = ""
        } else {
            textView.placeholder = "Compose new micropost..."
        }
    }

    func checkValidMicropostContent() {
        let text = contentField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }

    func showDeletingAlert() {
        let alertController = UIAlertController(title: "Are you sure you want to delete the picture?", message: "", preferredStyle: .ActionSheet)
        let logoutAction = UIAlertAction(title: "Delete", style: .Default) {
            action in self.pictureImageView.image = nil
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in println("Delete picture canceled")
        }

        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)

        presentViewController(alertController, animated: true, completion: nil)
    }
}
