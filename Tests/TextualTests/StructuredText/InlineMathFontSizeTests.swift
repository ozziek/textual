#if os(iOS) && !targetEnvironment(macCatalyst)
  import SnapshotTesting
  import SwiftUI
  import Testing

  @testable import Textual

  @MainActor
  struct InlineMathFontSizeTests {
    @Test(arguments: DynamicTypeSize.allCases)
    func inlineScriptsAcrossTextStyles(dynamicTypeSize: DynamicTypeSize) {
      let fonts: [(String, Font)] = [
        ("largeTitle", .largeTitle), ("title", .title), ("title2", .title2),
        ("title3", .title3), ("headline", .headline), ("subheadline", .subheadline),
        ("body", .body), ("callout", .callout), ("footnote", .footnote),
        ("caption", .caption), ("caption2", .caption2),
      ]
      let view = VStack(alignment: .leading, spacing: 16) {
        ForEach(fonts, id: \.0) { name, font in
          HStack(alignment: .firstTextBaseline, spacing: 24) {
            Text(name)
              .font(.system(size: 12))
              .frame(width: 90, alignment: .leading)
            StructuredText(markdown: "$2^{10}$", syntaxExtensions: [.math])
            StructuredText(markdown: "$O(2^d)$", syntaxExtensions: [.math])
          }
          .font(font)
        }
      }
      .environment(\.dynamicTypeSize, dynamicTypeSize)
      .fixedSize()
      .background(Color.guide)
      .padding()

      let fontSizes = fonts.map { _, font in
        FontScaled(CGFloat(1)).resolve(
          in: TextEnvironmentValues(font: font, dynamicTypeSize: dynamicTypeSize))
      }
      // Reserve the full sheet before Textual resolves its attachment placeholders.
      let layout = SwiftUISnapshotLayout.fixed(
        width: 170 + (fontSizes.max() ?? 0) * 5,
        height: fontSizes.reduce(32) { $0 + $1 * 2 + 16 }
      )

      assertSnapshot(
        of: view, as: .textualImage(layout: layout),
        named: String(describing: dynamicTypeSize)
      )
    }
  }
#endif
