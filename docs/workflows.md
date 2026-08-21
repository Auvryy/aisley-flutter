# Workflows

## Purpose
Defines **HOW** the mobile application behaves: step-by-step user flows, navigation triggers, and state transitions.

---

## 1. Customer Onboarding & Approval Lifecycle

```mermaid
graph TD
    A[Launch App] --> B[Buyer Login View]
    B -->|Click 'Register as Buyer'| C[3-Step Registration Wizard]
    C -->|Step 1: Personal Info & Age Validation| D[Step 2: Cascading Philippine Address]
    D --> E[Step 3: Government ID Upload & Terms]
    E -->|Submit Application| F[Pending Admin Approval]
    F -->|Admin Review In Progress| G[Buyer Approval View / Tracker]
    G -->|Admin Approves via Dashboard/Simulator| H[Approved Status]
    H -->|Sign In / Instant Transition| I[Buyer Main Navigation - 4 Tabs]
```

### States
- `unauthenticated`: Renders `BuyerLoginView`.
- `pendingApproval`: Renders `BuyerApprovalView` (milestones 1-4 with interactive Admin Simulator).
- `approved`: Renders `BuyerMainNavigation` (Home, Cart, Orders, Profile).

---

## 2. Product Discovery & Purchase Flow

```mermaid
graph TD
    A[Home Feed] -->|Tap Product Card| B[Quick Preview Bottom Sheet]
    B -->|Select Size/Color + Add to Cart| C[Cart Updated with Badge]
    B -->|Tap 'See Full Details & Reviews'| D[Full Product Detail Page]
    D -->|Swipe Images / Read Reviews / Explore Suggested| D
    D -->|Tap 'Chat with Atelier'| E[Concierge Chat Screen]
    D -->|Tap 'Add to Bag' or 'Direct Purchase'| F[Cart / Checkout]
    F --> G[Checkout Modal]
    G -->|Choose GCash/Maya/Card/COD + Place Order| H[Order Confirmed Dialog]
    H -->|Tap 'View Order Tracking'| I[Orders Tab with Milestone Timeline]
```

---

## 3. Post-Purchase Fulfillment & Feedback Lifecycle

```mermaid
graph TD
    A[Order Placed] --> B[To Ship: Atelier Preparation & Insured Packaging]
    B --> C[In Transit: Courier Handover & White-Glove Dispatch]
    C --> D[Out for Delivery: Final Mile Dispatch]
    D --> E[Delivered: Customer Received Parcel]
    E -->|Tap 'Rate & Review'| F[Rate & Feedback Modal]
    F -->|1-5 Stars + Comments + Photo| G[Review Published to Product Detail Page]
```
