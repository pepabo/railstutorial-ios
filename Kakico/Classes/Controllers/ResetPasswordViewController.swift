import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess
import SVProgressHUD

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var updateButton: UIButton!

    // MARK: - View Events
    override func viewDidLoad() {
        validateSubmitButton()
    }

    // MARK: - Actions
    @IBAction func touchUpdateButton(sender: UIButton) {
        resetPassword(passwordField.text)
    }

    @IBAction func unFocusTextField(sender: UITapGestureRecognizer) {
        hideKeyboard()
    }

    @IBAction func editingTextField(sender: AnyObject) {
        validateSubmitButton()
    }

    // MARK: - Navigation
    func moveToFeedView() {
        let feedView = storyboard!.instantiateViewControllerWithIdentifier("FeedNavigationController") as! UIViewController
        feedView.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(feedView, animated: true, completion: nil)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        validateSubmitButton()
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

    // MARK: - API request methods
    private func resetPassword(password: String) {
        hideKeyboard()
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)

        let params = [
            "password": password
        ]

        Alamofire.request(Router.UpdatePassword(params: params)).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            println(json["status"])
            if json["status"] == 200 {
                var keychain = Keychain(service: "nehan.Kakico")
                keychain["userId"] = json["user_id"].stringValue

                self.moveToFeedView()
            } else{
                SVProgressHUD.showErrorWithStatus(json["messages"]["user"].dictionary!.values.first?.stringValue)
            }
        }
    }

    // MARK: - Helpers
    func validateSubmitButton() {
        var result = true
        for textField : UITextField in textFields {
            result = result && textField.hasText()
        }
        updateButton.enabled = result
    }

    private func hideKeyboard() {
        for textField : UITextField in textFields {
        textField.resignFirstResponder()
        }
    }
}
