import Foundation

struct CurrencyFormat {
    static var inventory: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
}
