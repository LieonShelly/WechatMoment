//
//  SectionModel.swift
//  Arab
//
//  Created by lieon on 2018/9/12.
//  Copyright © 2018年lieon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class SectionModel<Section, ItemType>: SectionModelType, CustomStringConvertible {
    public typealias Identity = Section
    public typealias Item = ItemType
    public var model: Section
    
    public var identity: Section {
        return model
    }
    
    public var items: [Item]
    
    public init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
    
    public var description: String {
        return "\(self.model) > \(items)"
    }
    
    public required init(original: SectionModel<Section, Item>, items: [Item]) {
        self.model = original.model
        self.items = items
    }
}



