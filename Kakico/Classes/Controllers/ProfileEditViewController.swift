import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import KeychainAccess

class ProfileEditViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func submitProfileEditForm(sender: UIButton) {
        submit(nameTextField.text, email: emailTextField.text, password: passwordTextField.text, password_confirmation: confirmationTextField.text)
    }
    
    // MARK: - helpers
    
    func initForm() -> Void {
        let keychain = Keychain(service: "nehan.Kakico")
        if let userId = keychain["userId"] {
            Alamofire.request(Router.GetUser(userId: userId.toInt()!)).responseJSON { (request, response, data, error) -> Void in
                let json = JSON(data!)
                println(json)
                println(json["status"])
                if json["status"] == 200 {
                    self.nameTextField.text = json["contents"]["name"].string!
                    self.emailTextField.text = json["contents"]["email"].string!
                }
            }
        }
    }
    
    func submit(name: String, email: String, password: String, password_confirmation: String) {
        let params = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation
        ]
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
        Alamofire.request(Router.PostProfile(params: params)).responseJSON { (request, response, data, error) -> Void in
            let json = JSON(data!)
            println(json)
            println(json["status"])
            if json["status"] == 200 {
                SVProgressHUD.showSuccessWithStatus("Edit Succeeded!", maskType: .Black)
            } else{
                let tmp = json["messages"]["user"]
                SVProgressHUD.showErrorWithStatus(json["messages"]["user"].dictionary!.values.first?.stringValue)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
