//
//  editTableViewController.swift
//  phw19-1-todoList-UserDefaults
//
//  Created by jasonhung on 2024/1/7.
//

import UIKit

class EditTodoTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var noteTextView: UITextView!
    var placeholderLabel : UILabel!

    var todo: Todo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "bgEditTodo") )
        tableView.backgroundView?.alpha = 0.5
        
        updateUI()
        addPlaceholderLabel()

    }
    
    func addPlaceholderLabel(){
        
        // delegate code 寫在 extension 裡
        noteTextView.delegate = self
        
        //加 label
        placeholderLabel = UILabel()
        placeholderLabel.text = "請輸入備註"
        placeholderLabel.font = .italicSystemFont(ofSize: (noteTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        noteTextView.addSubview(placeholderLabel)
        
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (noteTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !noteTextView.text.isEmpty
        
        //加邊框
        noteTextView.layer.borderWidth = 1.0;
        noteTextView.layer.cornerRadius = 5;
        noteTextView.layer.borderColor = CGColor.init(gray: 0.9, alpha: 1)
    }
    
    func updateUI() {
        if let todo = todo {
            titleTextField.text = todo.title
            noteTextView.text = todo.note
        }
        
    }

    
  


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("EditTodoTableViewController - func prepare ")
        
        let title = titleTextField.text ?? ""
        let note = noteTextView.text ?? ""

        
        
        todo = Todo(title: title, note: note, isCompleted: false)
        print(todo!)
    }
 
}


extension EditTodoTableViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}
