//
//  MemoInteractor.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import Foundation

protocol MemoInteractorType: AnyObject {
    
}

final class MemoInteractor {
    weak var presenter: MemoPresenterType?

}

extension MemoInteractor: MemoInteractorType {
}
