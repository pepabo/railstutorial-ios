import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmationField: UITextField!
    @IBOutlet weak var updateButton: UIButton!

    // MARK: - View Events
    override func viewDidLoad() {
        updateButton.enabled = checkPresenceField()
    }

    // MARK: - Actions
    @IBAction func touchUpdateButton(sender: UIButton) {
        resetPassword(passwordField.text, password_confirmation: confirmationField.text)
    }

    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        hideKeyboard()
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        updateButton.enabled = checkPresenceField()
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 2 {
            textField.resignFirstResponder()
        } else {
            textFields[textField.tag].becomeFirstResponder()
        }
        return false
    }

    // MARK: -
    func moveToFeedView() {
        let feedView = self.storyboard!.instantiateViewControllerWithIdentifier("FeedNavigationController") as! UIViewController
        feedView.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(feedView, animated: true, completion: nil)
    }

    private func resetPassword(password: String, password_confirmation: String) {
        let params = [
            "password": password,
            "password_confirmation": password_confirmation
        ]

        hideKeyboard()
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)

        Alamofire.request(Router.UpdatePassword(params: params)).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            println(json["status"])
            if json["status"] == 200 {
                self.moveToFeedView()
            } else{
                SVProgressHUD.showErrorWithStatus(json["messages"]["user"].dictionary!.values.first?.stringValue)
            }
        }
    }

    func checkPresenceField() -> Bool{
        var result = true
        for textField : UITextField in textFields {
            result = result && textField.hasText()
        }
        return result
    }

    private func hideKeyboard() {
        for textField : UITextField in textFields {
        textField.resignFirstResponder()
        }
    }
}
