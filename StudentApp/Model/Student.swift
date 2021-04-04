//
//  Student.swift
//  StudentApp
//
//  Created by Алексей on 30.03.2021.
//

import Foundation

struct Student: Codable {

    var name: String
    var surname: String
    var averageScore: String
    
    var fullName: String {
        "\(name) \(surname)"
    }
}
