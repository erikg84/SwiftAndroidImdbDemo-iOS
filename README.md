# SwiftAndroidImdbDemo — iOS

iOS client app consuming the [SwiftAndroidIMDBSdk](https://github.com/erikg84/SwiftAndroidIMDBSdk). The SDK is pure Swift — on iOS it's a standard XCFramework consumed via SPM or local embedding.

## Technology Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| **UI** | SwiftUI | Hand-written screens that call SDK ViewModels |
| **SDK ViewModels** | Stateless command objects | `TMDBContainer.getHomeViewModel()` — no DI framework in the client |
| **State** | `@State` + `.task {}` | Each screen owns its own state, fetches in a `.task` block |
| **Project Generation** | XcodeGen | `project.yml` generates `.xcodeproj` |
| **SDK** | SwiftAndroidSDK.xcframework | Local framework (built from SDK repo) or via Gitea Swift Registry |

## Navigation

**Bottom tabs** (TMDB REST screens):
Home, Movies, TV, Search, Trending

**Sheet drawer** (GraphQL screens, via hamburger menu):
Countries, Continents, Languages

## How It Works

```swift
// Each screen — one SDK ViewModel, one @State, one .task
struct CountriesScreen: View {
    private let vm = TMDBContainer.getCountriesViewModel()
    @State private var state: UiState<[Country]> = .loading

    var body: some View {
        content.task { await load() }
    }

    private func load() async {
        let countries = try await vm.loadCountries()
        state = .loaded(countries)
    }
}
```

**No DI framework. No ViewModel wrappers. No shared state.** Each View calls exactly one SDK accessor.

## Screen Patterns

| Screen | SDK ViewModel | Pattern |
|--------|--------------|---------|
| Home | `TMDBHomeViewModel` | `.task` + `@State` |
| Movies | `TMDBMoviesViewModel` | Same |
| TV Shows | `TMDBTVShowsViewModel` | Same |
| Search | `TMDBSearchViewModel` | `.task(id: query)` + debounce |
| Trending | `TMDBTrendingViewModel` | `.task(id: window)` day/week toggle |
| Countries | `CountriesViewModel` | GraphQL, `.task` |
| Continents | `ContinentsViewModel` | GraphQL, `DisclosureGroup` |
| Languages | `LanguagesViewModel` | GraphQL, `.task` |

## Setup

1. **Build the SDK XCFramework** (one-time):
   ```bash
   cd /path/to/SwiftAndroidSdk
   bash scripts/build-xcframework.sh /tmp/xcf
   ```
2. **Copy the framework**:
   ```bash
   cp -R /tmp/xcf/SwiftAndroidSDK.xcframework Frameworks/
   ```
3. **TMDB credentials** in `tmdb-token.txt` (gitignored) or `TMDB_BEARER_TOKEN` env var
4. **Generate Xcode project**:
   ```bash
   brew install xcodegen
   xcodegen generate
   open SwiftAndroidImdbDemo.xcodeproj
   ```
5. Build and run on simulator (iOS 16+)

## License

MIT
