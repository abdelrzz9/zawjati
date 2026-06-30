import { test, expect } from "@playwright/test";

test.describe("Authentication", () => {
  test("shows login page", async ({ page }) => {
    await page.goto("/login");
    await expect(page.getByRole("heading", { name: /sign in/i })).toBeVisible();
    await expect(page.getByLabel(/email/i)).toBeVisible();
    await expect(page.getByLabel(/password/i)).toBeVisible();
  });

  test("shows validation errors on empty submit", async ({ page }) => {
    await page.goto("/login");
    await page.getByRole("button", { name: /sign in/i }).click();
    await expect(page.getByText(/required/i)).toBeVisible();
  });

  test("navigates to register", async ({ page }) => {
    await page.goto("/login");
    await page.getByRole("link", { name: /register/i }).click();
    await expect(page).toHaveURL(/\/register/);
  });

  test("shows forgot password link", async ({ page }) => {
    await page.goto("/login");
    await page.getByRole("link", { name: /forgot/i }).click();
    await expect(page).toHaveURL(/\/forgot-password/);
  });
});

test.describe("Chat", () => {
  test("shows empty state when no conversations", async ({ page }) => {
    await page.goto("/chat");
    await expect(page.getByText(/start a conversation/i)).toBeVisible();
  });

  test("new chat button is visible", async ({ page }) => {
    await page.goto("/chat");
    await expect(page.getByRole("button", { name: /new chat/i })).toBeVisible();
  });
});
