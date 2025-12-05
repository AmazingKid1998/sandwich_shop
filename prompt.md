## LLM Prompt for Implementing Cart Modification Features in a Flutter Sandwich Shop App

I am building a Flutter app for a sandwich shop. The app has two main pages:
- **Order Screen:** Users select sandwiches and add them to their cart.
- **Cart Screen:** Users view the items in their cart and see the total price.

I want to implement features that allow users to modify the items in their cart. Here are the features I need, with clear descriptions and expected behaviors:

---

### 1. Change Quantity of an Item

**Description:**  
Allow users to increase or decrease the quantity of a specific sandwich in their cart.

**Expected Behavior:**  
- The cart screen should display the current quantity for each item.
- Users can tap "+" to increase or "–" to decrease the quantity.
- If the quantity is decreased to 0, the item should be removed from the cart.
- The total price should update automatically as the quantity changes.

---

### 2. Remove an Item from the Cart

**Description:**  
Allow users to remove a sandwich from their cart entirely.

**Expected Behavior:**  
- Each item in the cart should have a "Remove" button (e.g., a trash icon).
- When the user taps "Remove," the item is deleted from the cart.
- The total price updates to reflect the removal.

---

### 3. Edit Item Details (Optional)

**Description:**  
Allow users to edit details of a sandwich in their cart (e.g., change bread type, toppings, or size).

**Expected Behavior:**  
- Each cart item should have an "Edit" button.
- Tapping "Edit" opens a dialog or navigates to a screen where the user can modify the sandwich options.
- After saving changes, the cart updates to reflect the new item details and price.

---

### General Requirements

- All changes should be reflected immediately in the UI.
- The cart's total price should always be accurate.
- The user should receive feedback (e.g., a snackbar) when an item is removed or updated.

---

**Please provide Flutter code and UI suggestions to implement these features.**