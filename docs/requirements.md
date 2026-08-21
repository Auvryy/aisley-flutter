# Requirements

## Purpose
Defines **WHAT** the Aisley Mobile Application (Flutter) must do for the Buyer experience.

---

## 1. Registration & KYC Verification
- **Personal Information**:
  - Last name\*
  - First name\*
  - Middle initial
  - Sex\* (`Female`, `Male`, `Non-Binary`, `Prefer not to say`)
  - E-mail\*
  - Contact No.\* (+63 9XX...)
  - Birthday\*
  - Age\* (auto-calculated from birthday, must validate $\ge 18$)
- **Address**:
  - Cascading Philippine dropdowns: Region/Province $\rightarrow$ City/Municipality $\rightarrow$ Barangay
  - Manual entry: Street, House/Unit number, Postal code
- **Government ID Upload**:
  - Valid ID types: PhilSys National ID, Philippine Passport, Driver's License, UMID, Postal ID, PRC ID, Voter's ID
  - Camera capture or document upload simulator with live preview thumbnail
- **Terms & Submission**:
  - Terms of Service & Discerning Buyer Code of Conduct agreement
  - 1-Click test auto-fill for rapid QA
  - Clear submission notice: *"After submitting your registration, please wait for the administrator's approval, which will be sent to your email."*

---

## 2. Authentication & Approval Gating
- **Login**:
  - Email & password with visibility toggle
  - Prototype 1-Click Fast Switchers:
    - `Approved Buyer (Sophia Rustia)` $\rightarrow$ Direct Storefront access
    - `Pending Buyer (Mateo Alcantara)` $\rightarrow$ Routes to Approval Status Tracker
- **Approval Gate**:
  - Account in `pendingApproval` cannot access the shopping bag or checkout.
  - Displays 4-milestone approval tracker:
    1. Registration Form Received (Done)
    2. Identity & Age Validation (Done)
    3. Administrator Clearance & Compliance Check (Under Review)
    4. Boutique Storefront & Cart Activation (Pending)
  - Interactive Admin Approval Simulator button allows testers to switch between `Pending` and `Approved`.

---

## 3. Main Menu & Storefront (4 Bottom Tabs)

### 3.1 Home / Discovery
- **Sticky Search Bar**: Permanently pinned at the top while scrolling via `SliverPersistentHeader(pinned: true)`.
- **Top AppBar Actions**: Concierge chat button with live unread badge counter + notifications button.
- **Lookbook Banner**: Haute Couture & Artisanal Lifestyle showcase.
- **Category Filter Pills**: Real-time filtering by luxury category with "View All Categories →" link.
- **Curated Product Grid**: 2-column display with prices in PHP (`₱14,850.00`), boutique tags, rating stars, and fast add-to-bag.

### 3.2 Product Details Flow
- **Quick Preview Sheet**: Opens on product card tap for rapid size/color selection, quantity counter, and Add to Cart.
- **"See Full Details & Reviews →"**: Opens the dedicated Full Product Page:
  - Multi-image swipeable gallery with indicators.
  - Atelier profile card with direct "Chat with Atelier" button.
  - Detailed craftsmanship story, material specifications, and authenticity guarantee.
  - **Clientele Reviews Section**: Star rating score, breakdown, and verified customer comments.
  - **"You May Also Like"**: Horizontal carousel of related curated items.
  - Sticky bottom action bar with Concierge inquiry, Add to Bag, and Direct Purchase.

### 3.3 Shopping Bag & Checkout
- Item selection checkboxes and quantity +/- stepper.
- Voucher applicator (`AISLEY15`, `AISLEYFIRST1000`) with clickable promo pills.
- Itemized pricing waterfall (Subtotal, Insured Delivery, Discount, Grand Total).
- **Checkout Modal**: Shipping address confirmation, payment method selection (**GCash**, **Maya**, **Credit/Debit Card**, **COD**), delivery notes, and instant order placement.

### 3.4 Orders & Tracking
- Status tabs: `All`, `To Ship`, `In Transit`, `Out for Delivery`, `Delivered`.
- Order cards with tracking codes, courier tags (**Aisley White Glove Express**, **Flash Express**, **J&T Express**), and milestone tracking timeline.
- **Rate & Feedback Modal**: 1–5 Star interactive rating, customer comments, and photo attachment simulator.

### 3.5 Account & Profile
- User header with VIP status and "Admin Verified Buyer" badge.
- Order metrics summary (To Ship, In Transit, Delivered) with direct links to Orders tab.
- **Marketplace Services & Shortcuts**: Direct access to **Boutique Concierge Chat** and **Categories & Atelier Directory**.
- Saved Philippine address and verified government ID document record.
- **Obsidian Noir Dark Mode** switcher.
- Prototype test controls and Sign Out.
