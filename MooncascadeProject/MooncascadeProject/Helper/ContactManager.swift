//
//  ContactManager.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 24/02/21.
//

import Combine
import ContactsUI

protocol ContactLoading {
    func fetchContacts() -> Future<[CNContact], Error>
}

class ContactManager: ContactLoading {
    func fetchContacts() -> Future<[CNContact], Error> {
        return Future { promise in
            var contacts = [CNContact]()
            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactViewController.descriptorForRequiredKeys()]
            let request = CNContactFetchRequest(keysToFetch: keys)
            let contactStore = CNContactStore()
            do {
                try contactStore.enumerateContacts(with: request) {
                    (contact, stop) in
                    contacts.append(contact)
                }
                promise(.success(contacts))
            }
            catch {
                promise(.failure(error))
            }
        }
    }
}
