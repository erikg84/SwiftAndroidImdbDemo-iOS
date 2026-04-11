import SwiftUI
import SwiftAndroidSDK

/// Search — debounced movie title search.
///
/// Mirrors the Android SearchScreen pattern: debouncing is a UI concern,
/// the SDK [TMDBSearchViewModel] is stateless. SwiftUI's `task(id:)`
/// modifier + `Task.sleep` provides the debounce.
struct SearchScreen: View {
    private let vm = TMDBContainer.getSearchViewModel()

    @State private var query: String = ""
    @State private var state: UiState<MoviePage> = .idle

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                content
            }
            .padding(.top)
            .navigationTitle("Search Movies")
            .searchable(text: $query, prompt: "Title")
            .task(id: query) { await load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle:
            Text("Type at least 2 characters to search.")
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
        case .failed(let msg):
            ErrorBanner(message: msg)
        case .loaded(let page):
            if page.results.isEmpty {
                Text("No results.")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            } else {
                List {
                    ForEach(page.results) { movie in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title).font(.headline)
                            Text("⭐ \(String(format: "%.1f", movie.voteAverage))  •  \(movie.releaseDate ?? "")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    private func load() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            state = .idle
            return
        }
        // 300ms debounce
        do {
            try await Task.sleep(nanoseconds: 300_000_000)
        } catch {
            return  // task cancelled — query changed
        }
        state = .loading
        do {
            let page = try await vm.search(query: trimmed, page: 1)
            state = .loaded(page)
        } catch is CancellationError {
            return
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
