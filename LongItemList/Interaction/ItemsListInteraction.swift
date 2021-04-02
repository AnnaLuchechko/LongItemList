//
//  ItemsListInteraction.swift
//  LongItemList
//
//  Created by Anna Luchechko on 02.04.2021.
//

import Foundation

protocol ItemsListInteractionProtocol {
    func fetchListItems(from: Int, limit: Int, completion: @escaping (Result<ListModel, ListItemError>) -> (Void))
}

final class ItemsListInteraction: ItemsListInteractionProtocol {
    
    let service = ItemsListService()
    
    func fetchListItems(from: Int, limit: Int, completion: @escaping (Result<ListModel, ListItemError>) -> (Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let list = self.service.generateListItems(from: from, limit: limit) {
                completion(.success(list))
            } else {
                completion(.failure(.listGenerationError))
            }
        }
    }

}
