import Foundation

/// Per-screen UI state. Each screen holds its own — there is no shared
/// state holder anywhere in the app. The SDK viewmodels are stateless
/// command objects.
enum UiState<T> {
    case idle
    case loading
    case loaded(T)
    case failed(String)
}
