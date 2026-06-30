import { describe, it, expect, vi, beforeEach } from "vitest";
import { useAuthStore } from "@/stores/auth-store";
import { apiClient } from "@/lib/api-client";

vi.mock("@/lib/api-client", () => ({
  apiClient: {
    setAccessToken: vi.fn(),
    post: vi.fn(),
  },
  ApiError: class ApiError extends Error {
    constructor(
      public status: number,
      message: string,
    ) {
      super(message);
      this.name = "ApiError";
    }
  },
}));

beforeEach(() => {
  useAuthStore.setState({
    user: null,
    isAuthenticated: false,
    isLoading: false,
    error: null,
  });
  localStorage.clear();
});

describe("AuthStore", () => {
  describe("login", () => {
    it("sets authenticated state on success", async () => {
      const mockRes = {
        access_token: "token",
        refresh_token: "refresh",
        user: { id: "1", email: "test@test.com", name: "Test" },
      };
      vi.mocked(apiClient.post).mockResolvedValueOnce(mockRes);

      await useAuthStore.getState().login("test@test.com", "pass");

      const state = useAuthStore.getState();
      expect(state.isAuthenticated).toBe(true);
      expect(state.user).toEqual(mockRes.user);
      expect(state.isLoading).toBe(false);
    });

    it("sets error on failure", async () => {
      vi.mocked(apiClient.post).mockRejectedValueOnce(
        new Error("Login failed"),
      );

      await useAuthStore.getState().login("test@test.com", "wrong");

      const state = useAuthStore.getState();
      expect(state.isAuthenticated).toBe(false);
      expect(state.isLoading).toBe(false);
    });
  });

  describe("logout", () => {
    it("clears auth state", async () => {
      useAuthStore.setState({
        user: { id: "1", email: "test@test.com", name: "Test" },
        isAuthenticated: true,
        isLoading: false,
        error: null,
      });

      await useAuthStore.getState().logout();

      const state = useAuthStore.getState();
      expect(state.isAuthenticated).toBe(false);
      expect(state.user).toBeNull();
    });
  });

  describe("register", () => {
    it("sets authenticated state on success", async () => {
      const mockRes = {
        access_token: "token",
        refresh_token: "refresh",
        user: { id: "1", email: "new@test.com", name: "New" },
      };
      vi.mocked(apiClient.post).mockResolvedValueOnce(mockRes);

      await useAuthStore.getState().register("New", "new@test.com", "pass");

      const state = useAuthStore.getState();
      expect(state.isAuthenticated).toBe(true);
      expect(state.user?.name).toBe("New");
    });
  });
});
