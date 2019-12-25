//
//  CasheService.swift
//  StocksApp
//
//  Created by  E.Tratotul on 30.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import CoreData

protocol ICasheService: AnyObject {
    func cache(user: UserPlain)
    func userExists(with login: String) -> Bool
    func activeUser() -> UserPlain?
    func retrieve(login: String) -> [StockDTO]
    func updateStocks(stocksDTO: [StockDTO])
    func checkForSigninnigIn(login:String, password: String) -> Bool
    func toggleUserActivity(isActive: Bool, login: String)
    
    
}


final class CacheService {
    let persistentContainer: NSPersistentContainer
    
    init(){
        self.persistentContainer = NSPersistentContainer(name: "StocksModel")
        self.persistentContainer.loadPersistentStores { ( _,error) in
            if let error = error {
                fatalError("Can't load persistent container \(error.localizedDescription)")
            }
        }
    }
    func save() {
        do {
            try self.persistentContainer.viewContext.save()
        } catch {
            assertionFailure("Can't save viewContext with error \(error.localizedDescription)")
        }
    }
}

extension CacheService: ICasheService {
    
    func cache(user: UserPlain) {
        
        let context = self.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        let managedUser = managedObject as! UserMO
        managedUser.login = user.login
        managedUser.password = user.password
        managedUser.isActive = user.isActive
        let array = user.stocks.map { stock -> StocksMO in
            let entity = NSEntityDescription.entity(forEntityName: "Stocks", in: context)
            let stockMO = StocksMO(entity: entity!, insertInto: context)
            stockMO.fillWithDTO(item:stock)
            return stockMO
        }
        
        managedUser.addToStocks(NSSet(array: array))
        save()
    }
    func activeUser() -> UserPlain? {
        let context = self.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "isActive == %d", true)
        
        do {
            let fetchResutls = try context.fetch(fetchRequest)
            guard let results = fetchResutls as? [UserMO], let activePerson = results.first else { return nil }
            return UserPlain(withMO: activePerson)
        } catch {
            assertionFailure("\(error) in \(#file): \(#function)")
            return nil
            
        }
    }
    
    func retrieve(login:String) -> [StockDTO] {
        let context = self.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        do {
            let fetchResults = try context.fetch(fetchRequest)
            guard let results = fetchResults as? [UserMO], let person = results.first else {
                return []
            }
            let array: [StocksMO] = person.stocks?.allObjects as! [StocksMO]
            return array.map { StockDTO(managedStock: $0) }
        }
            
        catch {
            fatalError()
        }
    }
    
    func updateStocks(stocksDTO: [StockDTO]) {
        let context = self.persistentContainer.viewContext
        let currentUser = "tratotul"
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "login == %@", currentUser)
        
        do {
            guard let results = try context.fetch(fetchRequest) as? [UserMO], let person = results.first else {
                return
                
            }
            person.stocks?.forEach { context.delete($0 as! NSManagedObject) }
            let array = stocksDTO.map { stock -> StocksMO in
                let entity = NSEntityDescription.entity(forEntityName: "Stocks", in: context)
                let stockMO = StocksMO(entity: entity!, insertInto: context)
                stockMO.fillWithDTO(item:stock)
                return stockMO
            }
            person.addToStocks(NSSet(array: array))
        }
        catch {
            assertionFailure("Can't obtain specific persons fom Database")
            return
        }
        save()
        
    }
    
    func userExists(with login: String) -> Bool {
        
        let context = self.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        
        do {
            guard let result = try context.fetch(fetchRequest) as? [UserMO] else {
                return false
            }
            return !(result.isEmpty)
        } catch {
            fatalError()
        }
    }
    
    func checkForSigninnigIn(login:String, password: String) -> Bool{
        
        let context = self.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "login == %@ AND password == %@", login, password)
        
        do {
            guard  let results = try context.fetch(fetchRequest) as? [UserMO] else {
                return false
            }
            return !results.isEmpty
        } catch {
            
        }
        return false
    }
    
    func toggleUserActivity(isActive: Bool, login: String) {
        let context = self.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        
        do {
            let results = try context.fetch(fetchRequest) as? [UserMO]
            guard let person = results?.first else { return }
            person.isActive = isActive
            save()
        } catch {
            print("\(error) occured in \(#file):\(#function)")
        }
    }
}


