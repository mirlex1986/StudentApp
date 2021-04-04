//
//  ViewController.swift
//  StudentApp
//
//  Created by Алексей on 30.03.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var surnameTextField: UITextField!
    @IBOutlet var scoreTextField: UITextField!
    
    private let dataManager = DataManager.shared
    
    var delegate: NewStudentViewControllerDelegate?
    var student: Student!
    var editFlag = true
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextFields()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        guard let student = checkCorrectFields() else { return }
        
        saveStudent(student: student)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldEditText(_ sender: UITextField) {
        guard let enteredChar = sender.text?.last?.lowercased() else { return }
        
        guard dataManager.rusChars.contains(enteredChar) || dataManager.engChars.contains(enteredChar) else {
            sender.text?.removeLast()
            showAlert(header: "Внимание!", message: "Имя и фамилия должны содержать только Русские или Английские символы")
            return
        }
        
    }

    @IBAction func scoreEntered(_ sender: UITextField) {
        guard let enteredChar = sender.text?.last else { return }
        let numbers = "12345"

        guard numbers.contains(enteredChar), (scoreTextField.text?.count) ?? 0 <= 1 else {
            sender.text?.removeLast()
            showAlert(header: "Внимание", message: "Средний балл может быть только от 1 до 5")
            return
        }
        
    }
    
    @IBAction func cancelButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    private func updateTextFields() {
        guard let student = student else { return }
        nameTextField.text = student.name
        surnameTextField.text = student.surname
        scoreTextField.text = student.averageScore
    }
    
    private func checkCorrectFields() -> Student? {
        guard let name = nameTextField.text ,
        let surname = surnameTextField.text,
        let averageScore = scoreTextField.text else { return nil }
        
        guard !name.isEmpty, !surname.isEmpty, !averageScore.isEmpty else {
            showAlert(header: "Внимание!", message: "Все поля обязательны к заполнению!")
            return nil
        }

        let student = Student(name: name, surname: surname, averageScore: averageScore)
        return student
    }
    
    private func saveStudent(student: Student) {
        if editFlag == true {
            dataManager.updateStudent(at: index, with: student)
        } else {
            dataManager.addStudent(student: student)
        }
        
        delegate?.saveStudent(student)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
}
//MARK: - Alert
extension ViewController {
    private func showAlert (header: String, message: String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
