import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.coreDataFileName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveToCoreData(_ items: [ItemModel]) {
        for item in items {
            let entity = NSEntityDescription.entity(forEntityName: "Foods", in: context)
            let newFood = NSManagedObject(entity: entity!, insertInto: context)
            newFood.setValue(item.id, forKey: "id")
            newFood.setValue(item.name, forKey: "name")
            newFood.setValue(item.image, forKey: "image")
            newFood.setValue(item.price, forKey: "price")

            do {
                try context.save()
            } catch {
                print("Failed saving: \(error)")
            }
        }
    }

    func fetchFromCoreData() -> [ItemModel] {
        var fetchData: [ItemModel] = []

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Foods")

        do {
            let fetchedResults = try context.fetch(fetchRequest)

            if let foods = fetchedResults as? [NSManagedObject] {
                for food in foods {
                    if let name = food.value(forKey: "name") as? String,
                       let id = food.value(forKey: "id") as? UUID,
                       let image = food.value(forKey: "image") as? String,
                       let price = food.value(forKey: "price") as? Float {
                        let item = ItemModel(id: id, image: image, name: name, price: price)
                        fetchData.append(item)
                    }
                }
            }
        } catch {
            print("Failed to fetch data: \(error)")
        }

        return fetchData
    }

    func cleanCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Foods")

        do {
            let fetchedResults = try context.fetch(fetchRequest)

            if let foods = fetchedResults as? [NSManagedObject] {
                for food in foods {
                    context.delete(food)
                }

                try context.save()
            }
        } catch {
            print("Failed to clean data: \(error)")
        }
    }
}
