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
    
    private var fetchRequest: CNContactFetchRequest {
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactViewController.descriptorForRequiredKeys()]
        return CNContactFetchRequest(keysToFetch: keys)
    }
    
    func fetchContacts() -> Future<[CNContact], Error> {
        return Future { [fetchRequest] promise in
            do {
                var contacts = [CNContact]()
                let contactStore = CNContactStore()
                try contactStore.enumerateContacts(with: fetchRequest) {
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
