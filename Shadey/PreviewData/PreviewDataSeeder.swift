import CoreData

enum PreviewDataSeeder {
    static func seed(into context: NSManagedObjectContext) {
        let request = Product.fetchRequest()
        request.fetchLimit = 1
        let hasProducts = (try? context.count(for: request)) ?? 0 > 0
        guard !hasProducts else { return }

        let now = Date()

        let developer = Product(context: context)
        developer.id = UUID()
        developer.name = "Coconut Developer"
        developer.brand = "Lumina"
        developer.productType = .developer
        developer.unit = .ounces
        developer.quantityPerUnit = 32
        developer.purchasePrice = 18
        developer.stockQuantity = 6
        developer.lowStockThreshold = 4
        developer.overstockThreshold = 12
        developer.defaultDeveloperRatio = 0
        developer.developerStrength = DeveloperStrength.vol20.rawValue
        developer.recommendedDeveloperStrength = 0
        developer.createdAt = now.addingTimeInterval(-86400 * 20)
        developer.updatedAt = now
        developer.barcode = "0123456789012"

        let colorA = Product(context: context)
        colorA.id = UUID()
        colorA.name = "7N Natural"
        colorA.brand = "Lumina"
        colorA.productType = .permanent
        colorA.unit = .ounces
        colorA.quantityPerUnit = 2
        colorA.purchasePrice = 9
        colorA.stockQuantity = 10
        colorA.lowStockThreshold = 3
        colorA.overstockThreshold = 12
        colorA.defaultDeveloperRatio = 1.5
        colorA.developerStrength = 0
        colorA.recommendedDeveloperStrength = DeveloperStrength.vol20.rawValue
        colorA.createdAt = now.addingTimeInterval(-86400 * 50)
        colorA.updatedAt = now
        colorA.barcode = "0987654321098"

        let colorB = Product(context: context)
        colorB.id = UUID()
        colorB.name = "8G Honey"
        colorB.brand = "Lumina"
        colorB.productType = .permanent
        colorB.unit = .ounces
        colorB.quantityPerUnit = 2
        colorB.purchasePrice = 9
        colorB.stockQuantity = 2
        colorB.lowStockThreshold = 3
        colorB.overstockThreshold = 10
        colorB.defaultDeveloperRatio = 1.5
        colorB.developerStrength = 0
        colorB.recommendedDeveloperStrength = DeveloperStrength.vol20.rawValue
        colorB.createdAt = now.addingTimeInterval(-86400 * 40)
        colorB.updatedAt = now
        colorB.barcode = "1111111111111"

        let lightener = Product(context: context)
        lightener.id = UUID()
        lightener.name = "Brightening Powder"
        lightener.brand = "Aura"
        lightener.productType = .lightener
        lightener.unit = .ounces
        lightener.quantityPerUnit = 16
        lightener.purchasePrice = 22
        lightener.stockQuantity = 5
        lightener.lowStockThreshold = 2
        lightener.overstockThreshold = 8
        lightener.defaultDeveloperRatio = 2
        lightener.developerStrength = 0
        lightener.recommendedDeveloperStrength = DeveloperStrength.vol30.rawValue
        lightener.createdAt = now.addingTimeInterval(-86400 * 30)
        lightener.updatedAt = now
        lightener.barcode = "2222222222222"

        let treatment = Product(context: context)
        treatment.id = UUID()
        treatment.name = "Bond Repair"
        treatment.brand = "Aurum"
        treatment.productType = .treatment
        treatment.unit = .ounces
        treatment.quantityPerUnit = 4
        treatment.purchasePrice = 14
        treatment.stockQuantity = 7
        treatment.lowStockThreshold = 2
        treatment.overstockThreshold = 8
        treatment.defaultDeveloperRatio = 0
        treatment.developerStrength = 0
        treatment.recommendedDeveloperStrength = 0
        treatment.createdAt = now.addingTimeInterval(-86400 * 18)
        treatment.updatedAt = now

        let clientA = Client(context: context)
        clientA.id = UUID()
        clientA.name = "Avery Clarke"
        clientA.notes = "Prefers warm tones."
        clientA.createdAt = now.addingTimeInterval(-86400 * 60)

        let clientB = Client(context: context)
        clientB.id = UUID()
        clientB.name = "Jordan Lee"
        clientB.notes = "Sensitive scalp; use gentle developer."
        clientB.createdAt = now.addingTimeInterval(-86400 * 30)

        let serviceA = Service(context: context)
        serviceA.id = UUID()
        serviceA.date = now.addingTimeInterval(-86400 * 5)
        serviceA.client = clientA
        serviceA.developer = developer
        serviceA.developerRatio = 1.5
        serviceA.developerAmountUsed = 3
        serviceA.notes = "Root touch-up and gloss."

        let formulaA = FormulaItem(context: context)
        formulaA.id = UUID()
        formulaA.product = colorA
        formulaA.amountUsed = 2
        formulaA.ratioPart = 1
        formulaA.cost = formulaA.amountUsed * colorA.costPerUnit
        formulaA.service = serviceA

        let formulaB = FormulaItem(context: context)
        formulaB.id = UUID()
        formulaB.product = colorB
        formulaB.amountUsed = 1
        formulaB.ratioPart = 0.5
        formulaB.cost = formulaB.amountUsed * colorB.costPerUnit
        formulaB.service = serviceA

        serviceA.formulaItems = Set([formulaA, formulaB])
        serviceA.totalCost = ServiceCalculator.totalCost(
            selections: [
                FormulaSelection(product: colorA, amountUsed: formulaA.amountUsed, ratioPart: formulaA.ratioPart),
                FormulaSelection(product: colorB, amountUsed: formulaB.amountUsed, ratioPart: formulaB.ratioPart)
            ],
            developer: developer,
            developerAmount: serviceA.developerAmountUsed
        )

        let serviceB = Service(context: context)
        serviceB.id = UUID()
        serviceB.date = now.addingTimeInterval(-86400 * 15)
        serviceB.client = clientB
        serviceB.developer = developer
        serviceB.developerRatio = 2
        serviceB.developerAmountUsed = 4
        serviceB.notes = "Partial highlights with treatment."

        let formulaC = FormulaItem(context: context)
        formulaC.id = UUID()
        formulaC.product = lightener
        formulaC.amountUsed = 2
        formulaC.ratioPart = 1
        formulaC.cost = formulaC.amountUsed * lightener.costPerUnit
        formulaC.service = serviceB

        let formulaD = FormulaItem(context: context)
        formulaD.id = UUID()
        formulaD.product = treatment
        formulaD.amountUsed = 1
        formulaD.ratioPart = 0.3
        formulaD.cost = formulaD.amountUsed * treatment.costPerUnit
        formulaD.service = serviceB

        serviceB.formulaItems = Set([formulaC, formulaD])
        serviceB.totalCost = ServiceCalculator.totalCost(
            selections: [
                FormulaSelection(product: lightener, amountUsed: formulaC.amountUsed, ratioPart: formulaC.ratioPart),
                FormulaSelection(product: treatment, amountUsed: formulaD.amountUsed, ratioPart: formulaD.ratioPart)
            ],
            developer: developer,
            developerAmount: serviceB.developerAmountUsed
        )

        let shoppingItem = ShoppingListItem(context: context)
        shoppingItem.id = UUID()
        shoppingItem.createdAt = now
        shoppingItem.isChecked = false
        shoppingItem.quantityNeeded = colorB.suggestedReorderQuantity
        shoppingItem.product = colorB

        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}
