//
//  UserSearchHistoryVM.swift
//  Chatty
//
//  Created by Clyde on 2023/06/17.
//

import SwiftUI
import CoreData

class UserSearchHistoryVM: ObservableObject {
    @Published var userSearchHistory: [UserSearchHistory] = []
    
    let coreDataManager = CoreDataManager.shared
    
    init() {
        coreDataManager.configure(modelName: "UserSearchHistoryModel")
        fetchSearches()
    }

    func fetchSearches() {
        let fetchRequest: NSFetchRequest<UserSearchHistory> = UserSearchHistory.fetchRequest()
        do {
            let userSearchHistory = try coreDataManager.context.fetch(fetchRequest)
            self.userSearchHistory = userSearchHistory
        } catch {
            print("Failed to fetch searches: \(error)")
        }
    }

    func addSearch(keyword: String) {
        deleteSearch(withKeyword: keyword)
        let newSearch = UserSearchHistory(context: coreDataManager.context)
        newSearch.date = Date()
        newSearch.keyword = keyword

        do {
            try coreDataManager.context.save()
            userSearchHistory.append(newSearch)
            self.fetchSearches()
        } catch {
            print("Failed to save search: \(error)")
        }
    }

    func deleteSearch(withKeyword keyword: String) {
        let fetchRequest: NSFetchRequest<UserSearchHistory> = UserSearchHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "keyword == %@", keyword)

        do {
            let userSearchHistory = try coreDataManager.context.fetch(fetchRequest)
            for search in userSearchHistory {
                coreDataManager.context.delete(search)
            }
            try coreDataManager.context.save()

            self.userSearchHistory = self.userSearchHistory.filter { $0.keyword != keyword }
            self.fetchSearches()
        } catch {
            print("Failed to delete search: \(error)")
        }
    }
    
    func deleteAllSearches() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserSearchHistory")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try coreDataManager.context.execute(batchDeleteRequest)
            userSearchHistory.removeAll()
            self.fetchSearches()
        } catch {
            print("Failed to delete all searches: \(error)")
        }
    }
}
