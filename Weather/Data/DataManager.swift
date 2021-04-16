//
//  DataManager.swift
//  Weather
//
//  Created by jh on 2021/04/16.
//

import Foundation
import CoreData

class DataManager {
    //싱글톤 구현
    static let shared = DataManager()
    private init() {}
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var cityList = [City]()
    
    //DB에서 데이터 읽어오기1. 페치리퀘스트 설정
    func fetchCity() {
        let request: NSFetchRequest<City> = City.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        do {
            cityList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
        
    }
    
    func addNewCity(_ map: Map){
        let newCity = City(context: mainContext)
        newCity.name = map.name
        newCity.longitude = map.longitude
        newCity.latitude = map.latitude
        newCity.insertDate = Date()
        
        
        cityList.insert(newCity, at: 0)
        saveContext()
    }
    
    func deleteCity(_ city: City!) {
        if let city = city {
            mainContext.delete(city)
            saveContext()
        }
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
