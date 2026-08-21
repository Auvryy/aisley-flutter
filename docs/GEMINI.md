# GEMINI.md — Master AI Context & System Specification

This file serves as the **authoritative system context** for AI pair programmers. When building, modifying, or extending `aisley_flutter` (and connecting with the web platform), you must strictly follow the rules, domain models, design system, and multi-role marketplace specifications outlined here. Do not hallucinate alternative colors, unapproved layouts, or different business logic.

---

## 1. System Overview & Core Philosophy

**Aisley** is a multi-tenant, universal e-commerce marketplace platform operating across four synchronized user roles:
1. **Buyer** (Current mobile focus in `aisley_flutter`) — Registers, gets approved by admin, browses products across universal categories, interacts with boutiques, manages cart, checks out via Philippine payment methods, tracks delivery milestones, and leaves reviews.
2. **Seller / Boutique Atelier** — Registers with business details, selects a **registered line of business / category**, uploads ID + business permit, gets approved by admin, manages inventory within their registered category, fulfills orders, schedules courier pickups, prints waybills, views profit analytics, and chats with buyers.
3. **Courier** — Registers with vehicle type, plate number, OR/CR, and driver's license, gets approved by admin, accepts delivery requests on a first-come first-served basis, picks up from seller, delivers to buyer, and tracks earnings.
4. **Admin** — Central authority that reviews/approves registration applications (buyers, sellers, couriers), monitors seller category compliance (ensures sellers only list products within their registered category), handles disputes, calculates 10% platform commission, and manages platform policies.

---

## 2. Universal Marketplace Categories (Taxonomy)

The platform is designed to support 14 universal categories. Each seller registers under their characteristic category, and buyers explore these categories to discover stores and items:

| # | Universal Category | Subcategories |
| :--- | :--- | :--- |
| 1 | **Pet Supplies** | Dog Food & Treats, Cat Litter & Accessories, Aquariums & Fish, Bird Feeders, Pet Grooming, Pet Health & Wellness |
| 2 | **Electronics and Gadgets** | Mobile Phones & Accessories, Laptops/Desktops/Monitors, Audio & Video Equipment, Smart Home, Cameras & Photography, Wearable Technology |
| 3 | **Women's Apparel** | Dresses & Skirts, Tops & Blouses, Activewear & Yoga Pants, Lingerie & Sleepwear, Jackets & Coats, Shoes & Accessories |
| 4 | **Men's Apparel** | Suits & Blazers, Casual Shirts & Pants, Outerwear & Jackets, Activewear & Fitness, Shoes & Accessories, Grooming |
| 5 | **Kids and Baby** | Baby Clothes & Accessories, Toys & Games, Educational Materials, Strollers & Gear, Nursery Furniture, Safety & Health |
| 6 | **Home and Garden** | Kitchen Appliances, Furniture & Decor, Gardening Tools, Outdoor Living, Home Improvement Tools, Bedding & Bath |
| 7 | **Sports and Outdoors** | Fitness Equipment, Camping & Hiking Gear, Sports Apparel, Cycling & Bikes, Water Sports, Team Sports Equipment |
| 8 | **Health and Beauty** | Skincare Products, Haircare Solutions, Makeup & Cosmetics, Personal Care Appliances, Men's Grooming, Health Supplements |
| 9 | **Books and Media** | Fiction & Non-Fiction, Magazines & Periodicals, Music CDs & Vinyl, Movie DVDs & Blu-ray, Video Games & Consoles, Educational DVDs |
| 10 | **Food and Gourmet** | Baking Supplies & Ingredients, Coffee/Tea/Beverages, Snacks & Candy, Specialty & International Cuisine, Organic Foods, Meal Kits |
| 11 | **Automotive & Motorcycle** | Protective Gear, Maintenance & Repair Tools, Parts & Accessories, Electrical Components, Tires/Wheels/Fluids |
| 12 | **Furniture and Office Equipment** | Office Desks & Chairs, Storage Cabinets & Shelving, Conference Furniture, Workstations, Ergonomic Accessories, Office Lighting |
| 13 | **Jewelry and Watches** | Necklaces & Pendants, Rings & Earrings, Bracelets & Bangles, Watches for Men & Women, Fashion Jewelry, Jewelry Storage & Care |
| 14 | **Office and School Supplies** | Notebooks & Paper, Writing Instruments, Office Furniture, Printers & Printing Supplies, School Bags & Backpacks, Arts & Crafts |

> **Compliance Rule**: Sellers must only post inventory that belongs to their registered Line of Business (Category). Admins verify this during compliance audits.

---

## 3. Design System & Visual Tokens

Always use these exact tokens from `lib/core/constants/colors.dart` and `theme.dart`:

```dart
// Brand Primary
AisleyColors.accentPink        = Color(0xFFE723A2); // Primary CTAs, active highlights
AisleyColors.pinkTint          = Color(0xFFFDF2F8); // Active pill fill, badge tint

// Light Theme (Canvas & Surfaces)
AisleyColors.lightCanvas       = Color(0xFFF8FAFC); // Main light background
AisleyColors.lightSurface      = Color(0xFFFFFFFF); // Cards & modal sheets
AisleyColors.lightBorder       = Color(0xFFE2E8F0); // Subtle borders
AisleyColors.textDarkPrimary   = Color(0xFF0F172A); // Headings & body text
AisleyColors.lightTextMuted    = Color(0xFF64748B); // Subtitles & metadata

// Obsidian Noir Dark Theme (Canvas & Surfaces)
AisleyColors.obsidianCanvas    = Color(0xFF0B0F19); // Deep dark background
AisleyColors.obsidianSurface   = Color(0xFF0F172A); // Dark card surfaces
AisleyColors.obsidianBorder    = Color(0xFF1E293B); // Dark borders
AisleyColors.textLightPrimary  = Color(0xFFF8FAFC); // Dark mode text
AisleyColors.obsidianTextMuted = Color(0xFF94A3B8); // Dark mode secondary text

// Status & Semantic Badges
AisleyColors.emeraldSuccess    = Color(0xFF10B981); // Verified, Delivered, Approved
AisleyColors.amberWarning      = Color(0xFFF59E0B); // Pending Review, In Transit
AisleyColors.roseDanger        = Color(0xFFE11D48); // To Ship, Danger, Errors
AisleyColors.electricSky       = Color(0xFF0284C7); // Info, Ateliers, Categories
```

### UI Rules:
- **Border Radius**: `12px` to `16px` for cards/inputs, `20px` to `24px` for banners/sheets.
- **Buttons**: Use `AisleyButton` component (`primary`, `outline`, `secondary`, `ghost`, `danger`). Button text is flexible and single-line.
- **Images**: Always use `AisleyNetworkImage` (`lib/core/widgets/aisley_image.dart`) for remote image rendering to guarantee fallback and widget test isolation.
- **Currency**: Always format Philippine Peso using `AisleyFormatters.formatPhp(amount)` $\rightarrow$ `₱14,850.00`.

---

## 4. Mobile Architecture & Code Structure

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
│   └── buyer_state.dart  # Reactive ChangeNotifier + BuyerStateProvider
└── main.dart             # Root entrypoint + DevicePreview wrapper
```

---

## 5. Navigation & Screen Workflows

### 4-Tab Bottom Navigation (`BuyerMainNavigation`)
1. **Home**:
   - **Sticky Search Bar**: Permanently pinned at the top via `SliverPersistentHeader(pinned: true)`.
   - **Top AppBar Actions**: Concierge Chat quick action with live unread counter badge + Notifications.
   - Lookbook hero banner, category pills, and 2-column product grid.
2. **Cart**:
   - Item selection checkboxes, quantity controls (+/-), voucher applicator (`AISLEY15`, `AISLEYFIRST1000`), price breakdown, and checkout modal (**GCash**, **Maya**, **Card**, **COD**).
3. **Orders**:
   - Status pipeline tabs (`All`, `To Ship`, `In Transit`, `Out for Delivery`, `Delivered`).
   - Waybill/courier tags (**Aisley White Glove**, **Flash**, **J&T**) and tracking timeline.
   - 1–5 Star review modal with customer comments and photo attachments.
4. **Profile**:
   - VIP Profile summary with "Admin Verified Buyer" badge.
   - Order metric shortcuts linking straight to Orders tab.
   - **Marketplace Services**: Direct links to **Concierge Chat** and **Categories & Atelier Directory**.
   - Saved Philippine address, verified ID document records, and Dark Mode toggle.

### Product Presentation Flow:
- **Card Tap**: Opens **Quick Preview Sheet** (`product_detail_sheet.dart`) for fast variant/quantity selection and Add to Cart.
- **"See Full Details & Reviews →"**: Pushes the **Full Product Detail Page** (`product_detail_page.dart`):
  - Swipeable multi-image carousel with indicators.
  - Atelier profile card with direct "Chat with Atelier" button.
  - Full craftsmanship story and specifications.
  - **Clientele Reviews Section** with star rating breakdown and verified customer comments.
  - **"You May Also Like"** horizontal curated suggestions.
  - Sticky bottom action bar with Chat, Add to Bag, and Direct Purchase.

---

## 6. Testing & Quality Guidelines

- **Zero-Warning Policy**: All code must pass `flutter analyze` with 0 issues.
- **Widget & Unit Tests**: All user flows and currency/age calculations must pass `flutter test`.
- **Responsive Frame**: `DevicePreview` enables realistic phone mockup on Chrome (`flutter run -d chrome`) and Linux desktop (`flutter run -d linux`), disabled automatically in production release mode (`!kReleaseMode`).
- **Documentation Policy**: Keep all documentation centralized under `docs/` and update `docs/PROGRESS.md` after every change with concise, minimal entries.
- **Commit Message Policy**: Always provide a clean, minimalistic Git commit message suggestion at the end of every response after making code or documentation changes.
