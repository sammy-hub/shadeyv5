import Foundation

/// Legacy compatibility - use AppFormatters.currency instead
struct CurrencyFormat {
    static var inventory: FloatingPointFormatStyle<Double>.Currency {
        AppFormatters.currency
    }
}
