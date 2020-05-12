import UIKit


/// UITextFieldDelegate:--? A set of optional methods that you use to manage the editing and validation of text in a text field object.
class EntryDetailViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    // I need a @IBOutlet of the clear button to style it
    @IBOutlet weak var clearBtnForStyle: UIButton!
    
    
    
    /*-------------------------------------------------------
    Use the didSet property observer to monitor changes to the
     entry properties value being set. Once the value of the
     entry property is set, we want to updateViews so the user
     sees the updated information. This needs to happen on the
     Main thread.
     -------------------------------------------------------*/
    // MARK: @Property-Observer
    var entry: Entry? {
        didSet {
            DispatchQueue.main.async {
                self.loadViewIfNeeded()
                self.updateViews()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        // Styling titleTextField, bodyTextField & clear button
        titleTextField.layer.cornerRadius = 20
        bodyTextField.layer.cornerRadius = 20
        
        clearBtnForStyle.layer.cornerRadius = 20
        clearBtnForStyle.layer.backgroundColor = UIColor.blue.cgColor
    }
    
    // MARK: _@IBAction
    /**©------------------------------------------------------------------------------©*/
    @IBAction func saveBtnTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let body = bodyTextField.text, !body.isEmpty else { return }
        
        EntryModelController.shared.createEntryWith(title: title, body: body) { (result) in
            DispatchQueue.main.async {
                /*-------------------------------------------------------
                 popViewController:--?
                 This method removes the top view controller from the
                 stack and makes the new top of the stack the active view
                 controller. If the view controller at the top of the stack
                 is the root view controller, this method does nothing. In
                 other words, you cannot pop the last item on the stack.
                 
                 -------------------------------------------------------*/
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // Clears the text field & body text from the viewcontroller
    @IBAction func clearTextBtnTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextField.text = ""
    }
    
    /**©------------------------------------------------------------------------------©*/
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextField.text = entry.body
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}// END OF CLASS
