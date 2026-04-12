import SwiftUI
import SwiftAndroidSDK

struct LanguagesScreen: View {
    private let vm = TMDBContainer.getLanguagesViewModel()
    @State private var state: UiState<[Language]> = .loading

    var body: some View {
        content
            .navigationTitle("Languages")
            .task { await load() }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            ProgressView()
        case .failed(let msg):
            ErrorBanner(message: msg)
        case .loaded(let languages):
            List(languages) { lang in
                HStack {
                    VStack(alignment: .leading) {
                        Text(lang.name ?? lang.code).font(.headline)
                        if let native = lang.nativeName {
                            Text(native).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Text(lang.code).font(.caption).foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
            .listStyle(.plain)
        }
    }

    private func load() async {
        state = .loading
        do {
            let languages = try await vm.loadLanguages()
            state = .loaded(languages)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
