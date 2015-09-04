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
        post(contentField.text, picture: pictureImageView.image)
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
        if picture == nil {
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
        } else {
            Alamofire.upload(
                Router.PostMicropostTest(),
                multipartFormData: { (multipartFormData) in
                    let data = NSData(data: UIImagePNGRepresentation(picture))
                    multipartFormData.appendBodyPart(data: data, name: "picture", mimeType: "image/png")

                    if let data = content.dataUsingEncoding(NSUTF8StringEncoding) {
                        multipartFormData.appendBodyPart(data: data, name: "content")
                    }
                },
                encodingCompletion: { (encodingResult) in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { request, response, JSON, error in
                            println(JSON)
                        }
                    case .Failure(let encodingError):
                        println(encodingError)
                    }
            })
        }
        
    }
}
