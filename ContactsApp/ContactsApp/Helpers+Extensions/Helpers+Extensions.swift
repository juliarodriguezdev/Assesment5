//
//  Helpers+Extensions.swift
//  ContactsApp
//
//  Created by Julia Rodriguez on 7/12/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
