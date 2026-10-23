#if os(iOS) && !targetEnvironment(macCatalyst)
  import SnapshotTesting
  import SwiftUI
  import Testing

  import Textual

  extension StructuredText {
    @MainActor
    struct MathExpressionTests {
      private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)

      @Test func inlineAndBlockMath() {
        let view = StructuredText(
          markdown: """
            Inline math feels natural: $E = mc^2$.

            $$\\int_{0}^{1} x^2\\,dx = \\frac{1}{3}$$

            ```math
            \\left( a + b \\right)^2 = a^2 + 2ab + b^2
            ```
            """,
          syntaxExtensions: [.math]
        )
        .background(Color.guide)
        .padding(.horizontal)

        assertSnapshot(of: view, as: .textualImage(layout: layout))
      }

      @Test func inlineScripts() {
        let view = VStack(alignment: .leading, spacing: 24) {
          inlineScriptExamples
            .font(.body)
          inlineScriptExamples
            .font(.title3)
        }
        .background(Color.guide)
        .padding(.horizontal)

        assertSnapshot(of: view, as: .textualImage(layout: layout))
      }

      private var inlineScriptExamples: some View {
        VStack(alignment: .leading, spacing: 16) {
          StructuredText(
            markdown: "What is $2^{10}$, approximately?",
            syntaxExtensions: [.math]
          )
          StructuredText(markdown: "$O(2^d)$", syntaxExtensions: [.math])
          StructuredText(markdown: "$x_{12}$ and $x_1^2$", syntaxExtensions: [.math])
        }
      }

      @Test func mathBlockAlignment() {
        let view = StructuredText(
          markdown: """
            Leading paragraph for context.

            $$a^2 + b^2 = c^2$$

            Trailing paragraph for context.
            """,
          syntaxExtensions: [.math]
        )
        .background(Color.guide)
        .padding(.horizontal)
        .multilineTextAlignment(.leading)
        .textual.mathProperties(.init(textAlignment: .trailing))

        assertSnapshot(of: view, as: .textualImage(layout: layout))
      }
    }
  }
#endif
