//
//  CommentDataStore.swift
//  Final Project_team8
//
//  Created by 이지원 on 6/16/24.
//

import Foundation

class CommentDataStore {
    static let shared = CommentDataStore()
    private var comments: [comment] = []

    func addComment(_ comment: comment) {
        comments.append(comment)
    }

    func getComments() -> [comment] {
        return comments
    }
}
