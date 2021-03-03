//
//  ContactManager.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 24/02/21.
//

import Foundation
import ContactsUI

class ContactManage {
    func fetchContacts(complition: @escaping (Result<[CNContact],Error>) -> Void) {
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactViewController.descriptorForRequiredKeys()]
        let request = CNContactFetchRequest(keysToFetch: keys)
        let contactStore = CNContactStore()
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                contacts.append(contact)
            }
            complition(.success(contacts))
        }
        catch {
            complition(.failure(error))
        }
    }
}
