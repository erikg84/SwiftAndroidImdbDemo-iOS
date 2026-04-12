import SwiftUI
import SwiftAndroidSDK

struct ContinentsScreen: View {
    private let vm = TMDBContainer.getContinentsViewModel()
    @State private var state: UiState<[Continent]> = .loading

    var body: some View {
        content
            .navigationTitle("Continents")
            .task { await load() }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            ProgressView()
        case .failed(let msg):
            ErrorBanner(message: msg)
        case .loaded(let continents):
            List(continents) { continent in
                DisclosureGroup {
                    ForEach(continent.countries) { country in
                        HStack {
                            Text(country.emoji)
                            Text(country.name)
                            Spacer()
                            Text(country.code).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                } label: {
                    HStack {
                        Text(continent.name).font(.headline)
                        Spacer()
                        Text("\(continent.countries.count) countries")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .listStyle(.plain)
        }
    }

    private func load() async {
        state = .loading
        do {
            let continents = try await vm.loadContinents()
            state = .loaded(continents)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
