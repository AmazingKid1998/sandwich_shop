# Worksheet 6 Requirements — AI-Driven Development and Navigation

This document consolidates the requirements for the features implemented in Worksheet 6 of the **Sandwich Shop** Flutter app.

It is an extension of prior work and should be treated as a living document aligned with Prompt-Driven Development (PDD). New tasks are appended rather than replacing completed ones.

---

## 1. Cart Modification Feature Requirements

### 1.1. Feature Description and Purpose

The Cart Modification feature enables users of the Sandwich Shop Flutter app to manage the contents of their cart before checkout.

Users can:
- adjust the quantity of each sandwich
- remove items entirely

Editing sandwich details (such as bread type or size) is not supported on the cart page; users must add a new item from the order screen if they wish to change sandwich options.

This feature aims to provide a flexible and user-friendly shopping experience, ensuring users can easily correct mistakes or change their order without starting over.

---

### 1.2. User Stories

#### 1.2.1. Adjust Quantity

- **As a user**, I want to increase or decrease the quantity of a sandwich in my cart, so I can order the exact number I want.
- **As a user**, I want the cart to automatically remove an item if I decrease its quantity below 1, so my cart never contains items with zero or negative quantity.

#### 1.2.2. Remove Item

- **As a user**, I want to remove a sandwich from my cart with a single action, so I can quickly update my order if I change my mind.

#### 1.2.3. Feedback and UI Responsiveness

- **As a user**, I want the cart and total price to update immediately when I make changes, so I always see an accurate summary of my order.
- **As a user**, I want to see a clear message if my cart is empty, so I know I need to add items before checking out.

---

### 1.3. Acceptance Criteria

#### 1.3.1. Quantity Adjustment

- [x] Each cart item displays "+" and "–" buttons for quantity adjustment.
- [x] Tapping "+" increases the quantity by 1.
- [x] Tapping "–" decreases the quantity by 1.
- [x] If the quantity is reduced below 1, the item is removed from the cart.
- [x] The total price updates automatically and accurately.
- [x] The UI updates immediately to reflect changes.

#### 1.3.2. Remove Item

- [ ] Each cart item has a "Remove" button (e.g., trash icon).
- [ ] Tapping "Remove" deletes the item from the cart.
- [ ] The total price updates accordingly.
- [ ] A snackbar or similar feedback is shown when an item is removed.

#### 1.3.3. General UI and Behavior

- [x] All changes are reflected immediately in the UI.
- [x] The cart's total price is always accurate.
- [x] The cart handles empty states gracefully (e.g., displays a message if empty).
- [x] The UI prevents negative quantities.

---

### 1.4. Subtasks

1. [x] Implement "+" and "–" quantity adjustment buttons for each cart item.
2. [x] Implement logic to remove an item if its quantity is reduced below 1.
3. [ ] Add a "Remove" button for each cart item.
4. [x] Ensure the total price and UI update immediately after any change.
5. [ ] Provide user feedback (snackbar) for remove and update actions.
6. [x] Handle empty cart states with a clear message.

---

## 2. Checkout Flow Requirements (Returning Data)

### 2.1. Feature Description and Purpose

A simple checkout flow demonstrates how Flutter screens can return data using `Navigator.pop(context, result)`.

The checkout screen displays an order summary and simulates payment processing.
On successful confirmation, it returns an order confirmation object to the cart screen, which clears the cart, shows a confirmation snackbar, and navigates back to the order screen.

---

### 2.2. User Stories

- **As a user**, I want to review an order summary before confirming payment.
- **As a user**, I want to see a processing indicator while payment is being simulated.
- **As a user**, I want to receive an order confirmation message after payment succeeds.
- **As a user**, I want my cart to be cleared automatically after successful checkout.

---

### 2.3. Acceptance Criteria

- [x] A `CheckoutScreen` exists and accepts a `Cart`.
- [x] The checkout page lists items and per-item prices derived via the Pricing repository.
- [x] The checkout page displays the total price.
- [x] Tapping "Confirm Payment" enters a processing state.
- [x] After a short simulated delay, the checkout screen returns:
  - orderId
  - totalAmount
  - itemCount
  - estimatedTime
- [x] If checkout returns a valid result:
  - the cart is cleared
  - a success snackbar is shown
  - navigation returns to the order screen
- [x] If the cart is empty, checkout cannot be started and an "empty cart" snackbar is shown.

---

### 2.4. Subtasks

1. [x] Create `CheckoutScreen`.
2. [x] Add widget tests for checkout UI and processing state.
3. [x] Integrate checkout navigation in `CartScreen`.
4. [x] Add/Update cart tests to cover the checkout button visibility and empty-cart behavior.

---

## 3. Named Routes and Web Routing Demo

### 3.1. Feature Description and Purpose

This task introduces named routes and demonstrates Flutter web hash-based routing.

An About screen is created and registered in `MaterialApp.routes`.

---

### 3.2. Acceptance Criteria

- [x] An `AboutScreen` exists with basic explanatory content.
- [x] `main.dart` includes a named route entry for `/about`.
- [x] The app can navigate to `/about` via `Navigator.pushNamed`.
- [x] On web, navigating directly to `#/about` shows the About screen.

---

### 3.3. Subtasks

1. [x] Create `AboutScreen`.
2. [x] Register `/about` in `main.dart`.
3. [x] Verify navigation works in-app and via the browser URL on web.

---

## 4. Exercise 1 — Profile Screen

### 4.1. Feature Description and Purpose

Add a new screen (Profile or Sign-Up/Sign-In) where users can enter and/or view basic details.
No real authentication or persistence is required yet.

A temporary link to this screen should be added at the bottom of the order screen.

---

### 4.2. User Stories

- **As a user**, I want a profile screen where I can enter basic identity details.
- **As a user**, I want to reach the profile screen via a simple link from the order page.

---

### 4.3. Acceptance Criteria

- [x] A `ProfileScreen` exists with basic input fields (e.g., name, email).
- [x] No authentication or persistence is required.
- [x] The order screen contains a temporary link/button to open `/profile`.
- [x] Widget tests exist for the profile screen.
- [x] Requirements document and profile/test evidence are ready for staff sign-off.

---

### 4.4. Subtasks

1. [x] Use AI to refine prompts and append this section to requirements.
2. [x] Create `ProfileScreen`.
3. [x] Add temporary link to profile at the bottom of `OrderScreen`.
4. [x] Add widget tests for Profile screen and Order link.

---

## 5. Exercise 2 — Global Drawer Navigation

### 5.1. Feature Description and Purpose

Improve navigation by adding a Drawer menu that provides access to the main screens:
- Order
- Cart
- Profile
- About

To reduce redundancy, create a reusable drawer widget (`AppDrawer`) and include it in each screen's scaffold.

---

### 5.2. User Stories

- **As a user**, I want to open a menu to navigate between major screens.
- **As a user**, I want consistent navigation patterns across screens.
- **As a developer**, I want to avoid duplicating drawer code on every screen.

---

### 5.3. Acceptance Criteria

- [x] A shared `AppDrawer` widget exists.
- [x] The Drawer includes navigation items for:
  - Order (`/`)
  - Cart (`/cart`) (fallback route acceptable for demo/tests)
  - Profile (`/profile`)
  - About (`/about`)
- [x] The Drawer is accessible from all main screens.
- [x] Redundant drawer layout code is avoided by reuse.
- [x] Widget tests cover the drawer’s presence and navigation.
- [x] Requirements document and navigation/test evidence are ready for staff sign-off.

---

### 5.4. Subtasks

1. [x] Create `AppDrawer`.
2. [x] Register named routes needed by the drawer.
3. [x] Add drawer to all relevant screens.
4. [x] Update/add widget tests for drawer navigation.

