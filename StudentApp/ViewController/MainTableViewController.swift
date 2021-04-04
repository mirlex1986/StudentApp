//
//  MainTableViewController.swift
//  StudentApp
//
//  Created by Алексей on 30.03.2021.
//

import UIKit
protocol NewStudentViewControllerDelegate {
    func saveStudent(_ student: Student)
}

class MainTableViewController: UITableViewController {
    
    private var students: [Student] = []
    private let dataManager = DataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        students = dataManager.fetchStudents()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let indexPath = tableView.indexPathForSelectedRow {
            let newStudentVC = segue.destination as! ViewController
            newStudentVC.student = students[indexPath.row]
            newStudentVC.delegate = self
            newStudentVC.editFlag = true
            newStudentVC.index = indexPath.row
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            let newStudentVC = segue.destination as! ViewController
            newStudentVC.student = nil
            newStudentVC.editFlag = false
            newStudentVC.delegate = self
        }
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let content = students[indexPath.row]
        cell.textLabel?.text = content.fullName
        cell.detailTextLabel?.text = "\(content.averageScore)"
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.deleteStudent(at: indexPath.row)
            students.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        performSegue(withIdentifier: "details", sender: student)
    }
    
    @IBAction func addNewStudentPressed(_ sender: Any) {
        performSegue(withIdentifier: "details", sender: nil)
    }
    
}

// MARK: - NewContactViewControllerDelegate
extension MainTableViewController: NewStudentViewControllerDelegate {
    func saveStudent(_ student: Student) {
        students = dataManager.fetchStudents()
        tableView.reloadData()
    }
}
