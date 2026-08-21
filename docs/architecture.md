# Architecture

## Purpose
Defines **HOW** the Aisley Mobile Application (Flutter) is structured: architecture patterns, tech stack, state management, directory layout, and design tokens.

## Tech Stack
- **Framework**: Flutter (Dart 3.x)
- **State Management**: `ChangeNotifier` + `InheritedNotifier` (`BuyerStateProvider`)
- **UI Engine**: Material 3 with custom luxury token extensions
- **Simulator / Frame**: `device_preview` (development mode only, guarded by `!kReleaseMode`)
- **Testing**: `flutter_test` (Unit & Widget testing)

## Directory Layout
```
lib/
├── core/
│   ├── constants/        # colors.dart, theme.dart
│   ├── data/             # mock_buyer_data.dart, philippine_addresses.dart
│   ├── models/           # address.dart, buyer_profile.dart, product.dart, cart_item.dart, order.dart, voucher.dart, chat.dart
│   ├── utils/            # formatters.dart (PHP currency, age calculator, dates)
│   └── widgets/          # aisley_button.dart, aisley_text_field.dart, aisley_image.dart, status_badge.dart
├── features/
│   ├── auth/             # buyer_login_view.dart, buyer_register_wizard.dart, buyer_approval_view.dart
│   ├── shop/             # buyer_home_view.dart, product_detail_sheet.dart, product_detail_page.dart
│   ├── categories/       # buyer_categories_view.dart
│   ├── cart/             # buyer_cart_view.dart, checkout_modal.dart
│   ├── orders/           # buyer_orders_view.dart, rate_feedback_modal.dart
│   ├── chat/             # buyer_chat_view.dart
│   ├── account/          # buyer_account_view.dart
│   └── buyer_main_navigation.dart # 4-destination bottom navigation root
├── state/
│   └── buyer_state.dart  # Reactive state container + provider
└── main.dart             # Root entrypoint + DevicePreview wrapper
```

## Design System & Color Tokens

```dart
// Brand Accent
AisleyColors.accentPink       = Color(0xFFE723A2); // Primary CTA, highlights, active nav
AisleyColors.pinkTint         = Color(0xFFFDF2F8); // Active pill & selection fill

// Light Theme (Canvas & Surfaces)
AisleyColors.lightCanvas      = Color(0xFFF8FAFC); // App background
AisleyColors.lightSurface     = Color(0xFFFFFFFF); // Card background
AisleyColors.lightBorder      = Color(0xFFE2E8F0); // Subtle card/input borders
AisleyColors.textDarkPrimary  = Color(0xFF0F172A); // Primary headings & titles
AisleyColors.lightTextMuted   = Color(0xFF64748B); // Subtitles & metadata

// Obsidian Noir Dark Theme (Surfaces & Canvas)
AisleyColors.obsidianCanvas   = Color(0xFF0B0F19); // Pure dark background
AisleyColors.obsidianSurface  = Color(0xFF0F172A); // Dark card surface
AisleyColors.obsidianBorder   = Color(0xFF1E293B); // Dark border
AisleyColors.textLightPrimary = Color(0xFFF8FAFC); // Dark mode text
AisleyColors.obsidianTextMuted= Color(0xFF94A3B8); // Dark mode muted text

// Status & Semantic Badges
AisleyColors.emeraldSuccess   = Color(0xFF10B981); // Verified, Delivered, Approved
AisleyColors.amberWarning     = Color(0xFFF59E0B); // Pending Review, In Transit
AisleyColors.roseDanger       = Color(0xFFE11D48); // Errors, Destructive, To Ship
AisleyColors.electricSky      = Color(0xFF0284C7); // Info, Ateliers, Categories
```

## UI Geometry & Rules
- **Border Radiuses**:
  - Buttons & standard cards: `12px` to `16px`
  - Hero banners & modal bottom sheets: `20px` to `24px`
  - Small chips & tags: `6px` to `8px`
- **Buttons**: Use `AisleyButton` with variants (`primary`, `outline`, `secondary`, `ghost`, `danger`). Text is wrapped with `Flexible` to prevent row overflows.
- **Images**: Always use `AisleyNetworkImage` (`lib/core/widgets/aisley_image.dart`) for remote image rendering to ensure automatic placeholders and test isolation.

## Navigation & Screen Architecture
- **Root Shell**: `BuyerMainNavigation` with **4 Bottom Destinations**:
  1. **Home**: Sticky search bar via `SliverPersistentHeader(pinned: true)`, lookbook hero banner, category pills, product grid, and Concierge Chat AppBar action.
  2. **Cart**: Bag items, quantity controls (+/-), voucher applicator (`AISLEY15`, `AISLEYFIRST1000`), price breakdown, and checkout modal.
  3. **Orders**: Pipeline filter tabs, courier milestones tracking timeline, and 1–5 star review feedback modal.
  4. **Profile**: User summary, verified KYC badge, order metrics, marketplace services shortcuts, address records, theme switcher, and prototype test controls.
- **Product Details Flow**:
  - Tapping a product card opens the **Quick Preview Sheet** (`product_detail_sheet.dart`).
  - Tapping **"See Full Details & Reviews →"** pushes the **Full Product Page** (`product_detail_page.dart`) with image carousel, atelier card, reviews, and "You May Also Like" recommendations.
