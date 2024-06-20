//
//  comment.swift
//  Final Project_team8
//
//  Created by 이지원 on 6/16/24.
//

import Foundation

struct comment: Identifiable {
    let id = UUID()
    let user: String
    let text: String
}
