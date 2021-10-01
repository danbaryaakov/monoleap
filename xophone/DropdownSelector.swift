import SwiftUI

protocol DropDownOptionImpl : Hashable {
    var key: String { get }
    var value: String { get }
}

struct DropdownOption: DropDownOptionImpl {
    let key: String
    let value: String

    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool {
        return lhs.key == rhs.key
    }
}

struct DropdownRow: View {
    var option: DropdownOption
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    var body: some View {
        Button(action: {
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option)
            }
        }) {
            HStack {
                Text(self.option.value)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}

struct Dropdown: View {
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(self.options, id: \.self) { option in
                        DropdownRow(option: option, onOptionSelected: self.onOptionSelected)
                    }
                }
            }
        }
        .frame(minHeight: 180, maxHeight: 180)
        .padding(.vertical, 5)
        .background(MonoleapAssets.sectionBackground)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10).strokeBorder(
                MonoleapAssets.controlColor
            )
        )
    }
}

struct DropdownSelector: View {
    @State private var shouldShowDropdown = false
    @State var selectedOption: DropdownOption?
    var placeholder: String
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    
    private let buttonHeight: CGFloat = 45
    
    func select(_ key: String) {
        selectedOption = options.first(where: { $0.key == key })
    }
    
    var body: some View {
        Button(action: {
            self.shouldShowDropdown.toggle()
        }) {
            HStack {
                Text(selectedOption == nil ? placeholder : selectedOption!.value)
                    .font(.system(size: 14))
                    .foregroundColor(selectedOption == nil ? .black: .white)

                Spacer()

                Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 5)
                    .font(Font.system(size: 9, weight: .medium))
                    .foregroundColor(MonoleapAssets.controlColor)
            }
        }
        .padding(.horizontal)
        .cornerRadius(10)
        .frame(height: self.buttonHeight)
        .overlay(
            RoundedRectangle(cornerRadius: 10).strokeBorder(
                MonoleapAssets.controlColor
            )
        )
        .overlay(
            VStack {
                if self.shouldShowDropdown {
                    Spacer(minLength: buttonHeight + 5)
                    Dropdown(options: self.options, onOptionSelected: { option in
                        shouldShowDropdown = false
                        selectedOption = option
                        self.onOptionSelected?(option)
                    }).zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                }
            }, alignment: .topLeading
        )
        .background(
            RoundedRectangle(cornerRadius: 10).fill(MonoleapAssets.sectionBackground)
        )
    }
}

struct DropdownSelector_Previews: PreviewProvider {
    static var uniqueKey: String {
        UUID().uuidString
    }

    static let options: [DropdownOption] = [
        DropdownOption(key: uniqueKey, value: "Sunday"),
        DropdownOption(key: uniqueKey, value: "Monday"),
        DropdownOption(key: uniqueKey, value: "Tuesday"),
        DropdownOption(key: uniqueKey, value: "Wednesday"),
        DropdownOption(key: uniqueKey, value: "Thursday"),
        DropdownOption(key: uniqueKey, value: "Friday"),
        DropdownOption(key: uniqueKey, value: "Saturday")
    ]


    static var previews: some View {
        Group {
            DropdownSelector(
                selectedOption: options[3],
                placeholder: "Day of the week",
                options: options,
                onOptionSelected: { option in
                    print(option)
            })
            .padding(.horizontal)
        }
    }
}
