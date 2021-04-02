//
//  ItemsListService.swift
//  LongItemList
//
//  Created by Anna Luchechko on 02.04.2021.
//

import Foundation

protocol ItemsListServiceProtocol {
    func generateListItems(from: Int, limit: Int) -> ListModel?
}

final class ItemsListService: ItemsListServiceProtocol {
    
    func generateListItems(from: Int, limit: Int) -> ListModel? {
        var index = from
        var listItems: [ListItemModel] = []
        let endIndex = from + limit
        for item in from...endIndex {
            let name = String(format: "%010d", item)
            let loremIpsumWords = Constants.loremIpsumText.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            let wordsCount = (index % 15) + (index % 5)
            let description = loremIpsumWords[0...wordsCount]
            let listItem = ListItemModel(name: name, desription: description.joined(separator: " "))
            listItems.append(listItem)
            index += 1
        }
        return ListModel(count: Constants.totalItemsCount, items: listItems)
    }

}
