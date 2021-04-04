//
//  DataManager.swift
//  StudentApp
//
//  Created by Алексей on 30.03.2021.
//

import Foundation

class DataManager {
    static var shared = DataManager()
    
    let rusChars = "йцукенгшщзхъфывапролджэёячсмитьбю"
    let engChars = "qwertyuiopasdfghjklzxcvbnm"
    
    private let userDefaults = UserDefaults.standard
    private let studentKey = "students"
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private init() {
        archiveURL = documentDirectory.appendingPathComponent("Students").appendingPathExtension("plist")
    }
    
    func addStudent(student: Student) {
        var students = fetchStudents()
        students.append(student)
        guard let data = try? PropertyListEncoder().encode(students) else { return }
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
    
    func fetchStudents() -> [Student] {
        guard let data = try? Data(contentsOf: archiveURL) else { return [] }
        guard let students = try? PropertyListDecoder().decode([Student].self, from: data) else { return [] }
        return students
    }
    
    func deleteStudent(at index: Int) {
        var students = fetchStudents()
        students.remove(at: index)
        guard let data = try? PropertyListEncoder().encode(students) else { return }
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
    
    func updateStudent(at index: Int, with student: Student) {
        var students = fetchStudents()
        students[index] = student
        guard let data = try? PropertyListEncoder().encode(students) else { return }
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
}
