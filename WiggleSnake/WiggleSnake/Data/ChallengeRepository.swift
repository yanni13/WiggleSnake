//
//  ChallengeRepository.swift
//  WiggleSnake
//
//  Created by 아우신얀 on 4/17/25.
//

//import CoreData
//import Foundation
//
//protocol ChallengeRepositoryProtocol {
//    func fetchAllChallenges() -> [ListItemModel]
//}
//
//final class DefaultChallengeRepository: ChallengeRepositoryProtocol {
//    private let context: NSManagedObjectContext
//
//    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
//        self.context = context
//    }
//
//    func fetchAllChallenges() -> [ListItemModel] {
//        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "dateRange", ascending: true)]
//        
//        do {
//            let result = try context.fetch(request)
//            return result.compactMap { $0.toListItemModel() }
//        } catch {
//            print("CoreData fetch error: \(error)")
//            return []
//        }
//    }
//}
