import SwiftUI
import SwiftAndroidSDK

struct CountriesScreen: View {
    private let vm = TMDBContainer.getCountriesViewModel()
    @State private var state: UiState<[Country]> = .loading

    var body: some View {
        content
            .navigationTitle("Countries")
            .task { await load() }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            ProgressView()
        case .failed(let msg):
            ErrorBanner(message: msg)
        case .loaded(let countries):
            List(countries) { country in
                HStack {
                    Text(country.emoji).font(.largeTitle)
                    VStack(alignment: .leading) {
                        Text(country.name).font(.headline)
                        Text(country.currency ?? "—").font(.subheadline).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(country.code).font(.caption).foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
            .listStyle(.plain)
        }
    }

    private func load() async {
        state = .loading
        do {
            let countries = try await vm.loadCountries()
            state = .loaded(countries)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
