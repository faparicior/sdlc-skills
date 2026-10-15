# Guidance for Product Vision & Boundaries

This guide provides "Brew Guidance" and generic examples to help you complete the `1-product-vision-and-boundaries.md` template effectively.

---

## 1.1 The Elevator Pitch

### 🍺 Brew Guidance (How to brew a good Elevator Pitch)

*   **Clarity above all:** You have 30 seconds (the length of an elevator ride). If you can't explain your product by filling in these blanks, your idea is likely too complex or vague.
*   **The "Unlike" is key:** Don't ignore the competitors. Defining who you are fighting against (or what manual alternative you are replacing, like "Excel") helps understand your value immediately.
*   **Be specific with the "Who":** Avoid saying "For everyone". A product for everyone is a product for no one. Be concrete (e.g., "Sales Managers", "University Students").

### 🧪 Generic Examples

**Example 1: A Management Tool (B2B)**

| Field | Example |
| :--- | :--- |
| **For** | Remote software development teams |
| **Who** | Struggle with lack of work visibility and excessive status meetings |
| **The Product** | *DevTracker* (Fictional Name) |
| **Is a** | Automated project manager |
| **That** | Connects to your code repository to update task status automatically |
| **Unlike** | Jira or Trello |
| **Our Product** | Eliminates the need to move cards manually, saving 1 hour per developer per week |

**Example 2: A Consumer Service (B2C)**

| Field | Example |
| :--- | :--- |
| **For** | Busy urban pet owners |
| **Who** | Worry about leaving their dogs alone at home during long workdays |
| **The Product** | *DogWalk Hero* (Fictional Name) |
| **Is a** | On-demand dog walking platform |
| **That** | Connects owners with certified walkers in less than 15 minutes |
| **Unlike** | Leaving a key with a neighbor or distant dog daycares |
| **Our Product** | Offers live GPS tracking of the walk and veterinary insurance included in every booking |

**Example 3: A Non-Profit Initiative (Social Impact)**

| Field | Example |
| :--- | :--- |
| **For** | Organizers of small community events |
| **Who** | Have zero budget and limited technical skills |
| **The Product** | *OpenMeetup* (Fictional Name) |
| **Is a** | Simple event publishing website |
| **That** | Allows creating a registration page in 3 clicks without servers or costs |
| **Unlike** | Eventbrite (charges fees) or Meetup (has a monthly subscription) |
| **Our Product** | Is 100% free, open-source, and does not sell attendee data |

---

## 1.2 Product Goals

### 🍺 Brew Guidance (How to brew a good goal)

*   **Outcomes over Outputs:** Do not list *features* (e.g., "Build a dashboard"). List the *result* of that feature (e.g., "Give managers real-time visibility to reduce decision lag").
*   **The Rule of 3:** Stick to **3 top-level goals**. If you have 10 priorities, you have no priorities. Focus on what determines "Success" vs "Failure" for the MVP.
*   **Mix the Flavor:** Ideally, balance the goals across different perspectives:
    *   **Business:** Growth, Revenue, Market Share.
    *   **User:** Satisfaction, Ease of Use, Time Saved.
    *   **Learning/Strategic:** Validating a risky assumption, proving a technology.

### 🧪 Generic Examples

**For a B2B SaaS (Growth Focused)**
1.  **Acquisition:** Acquire 50 beta companies in the first 3 months.
2.  **Efficiency:** Reduce the customer's "Time-to-Value" from 2 weeks to < 24 hours.
3.  **Validation:** Validate that users are willing to pay at least $50/month for the core feature.

**For an Internal Enterprise Tool (Efficiency Focused)**
1.  **Cost:** Reduce manual data-entry costs by 40% within the Finance department.
2.  **Speed:** Reduce the average "Request Approval" time from 5 days to 4 hours.
3.  **Error Rate:** Decrease data entry errors to near 0%.

**For a Consumer App (Engagement Focused)**
1.  **Retention:** Achieve a Day-30 retention rate of 25%.
2.  **Virality:** Achieve a K-factor > 1 (Each user invites at least one other user).
3.  **Satisfaction:** Maintain a 4.8-star rating on the App Store.

**For a Migration/Modernization Project**
1.  **Continuity:** Ensure 100% data integrity during the migration (Lossless transfer).
2.  **Performance:** Improve page load time by 50% compared to the legacy system.
3.  **Cost:** Decommission the legacy mainframe servers by Q4.

---

## 1.3 Is/Is Not, Does/Does Not

### 🍺 Brew Guidance (How to draw the line)

*   **The Power of "NOT":** It is easy to say what the product *is*. It is much harder (and more valuable) to agree on what it *is not*. This prevents scope creep. If you say "The Product IS NOT a generic CRM," you just saved the team months of unnecessary work.
*   **Is vs. Does:**
    *   **IS/IS NOT:** Defines the **identity** or **quality** of the product (Adjectives). *Examples: Fast, Secure, Mobile-first.*
    *   **DOES/DOES NOT:** Defines the **functionality** or **scope** (Verbs). *Examples: Send emails, Process payments, integrate with Zoom.*
*   **The "Does Not" Trap:** "Does Not" doesn't mean "Never". It usually means "Not in the MVP" or "Not in the Core Value Proposition". It's a strategic choice for *now*.

### 🧪 Generic Examples

**Example 1: A Chat Application (Identity & Scope)**

| The Product **IS** | The Product **IS NOT** |
| :--- | :--- |
| Real-time communication tool | A project management system |
| Mobile-first | A desktop replacement |
| Secure (End-to-end encrypted) | A social network (no public feeds) |
| Lightweight | Bloated with enterprise features |

| The Product **DOES** | The Product **DOES NOT** |
| :--- | :--- |
| Send text and images | Support video calls (in V1) |
| Sync across devices | Store message history forever |
| Allow group chats | Integrate with Calendar apps |
| Support push notifications | Offer AI-generated replies |

**Example 2: An E-commerce Store (Focus on Niche)**

| The Product **IS** | The Product **IS NOT** |
| :--- | :--- |
| A curated marketplace for handmade goods | A general store like Amazon |
| Community-driven | A drop-shipping platform |
| High-end / Premium feel | A discount / coupon site |

| The Product **DOES** | The Product **DOES NOT** |
| :--- | :--- |
| Handle secure payments (Stripe) | Manage inventory logistics (Sellers do it) |
| Allow user reviews | Offer "Same Day Delivery" |
| Suggest personalized items | Support cryptocurrency payments |

**Example 3: An Internal Reporting Tool (Focus on Speed)**

| The Product **IS** | The Product **IS NOT** |
| :--- | :--- |
| A read-only dashboard | A data-entry system |
| Fast (loads in < 1s) | Real-time (data is T-1 day) |
| Accessible via Browser | A native mobile app |

| The Product **DOES** | The Product **DOES NOT** |
| :--- | :--- |
| Aggregate sales data | Allow editing of sales records |
| Export to PDF | Send email alerts |
| Filter by Region | Offer predictive analytics (AI) |
