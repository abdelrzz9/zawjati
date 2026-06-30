import { create } from "zustand";
import { apiClient, ApiError } from "@/lib/api-client";
import type { User } from "@/types";

const REFRESH_TOKEN_KEY = "zawjati_refresh_token";

function getStoredRefreshToken(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem(REFRESH_TOKEN_KEY);
}

function setStoredRefreshToken(token: string | null) {
  if (typeof window === "undefined") return;
  if (token) {
    localStorage.setItem(REFRESH_TOKEN_KEY, token);
  } else {
    localStorage.removeItem(REFRESH_TOKEN_KEY);
  }
}

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
  login: (email: string, password: string) => Promise<void>;
  register: (name: string, email: string, password: string) => Promise<void>;
  logout: () => void;
  checkAuth: () => Promise<void>;
  clearError: () => void;
}

export const useAuthStore = create<AuthState>((set, get) => ({
  user: null,
  isAuthenticated: false,
  isLoading: true,
  error: null,

  login: async (email, password) => {
    set({ isLoading: true, error: null });
    try {
      const res = await apiClient.post<{
        access_token: string;
        refresh_token: string;
        user: User;
      }>("/auth/login", { email, password });

      apiClient.setAccessToken(res.access_token);
      setStoredRefreshToken(res.refresh_token);

      set({ user: res.user, isAuthenticated: true, isLoading: false });
    } catch (e) {
      const message = e instanceof ApiError ? e.message : "Login failed";
      set({ error: message, isLoading: false });
    }
  },

  register: async (name, email, password) => {
    set({ isLoading: true, error: null });
    try {
      const res = await apiClient.post<{
        access_token: string;
        refresh_token: string;
        user: User;
      }>("/auth/register", { name, email, password });

      apiClient.setAccessToken(res.access_token);
      setStoredRefreshToken(res.refresh_token);

      set({ user: res.user, isAuthenticated: true, isLoading: false });
    } catch (e) {
      const message = e instanceof ApiError ? e.message : "Registration failed";
      set({ error: message, isLoading: false });
    }
  },

  logout: async () => {
    try {
      await apiClient.post("/auth/logout");
    } catch {
      // Proceed with local logout even if server call fails
    }
    apiClient.setAccessToken(null);
    setStoredRefreshToken(null);
    set({ user: null, isAuthenticated: false });
  },

  checkAuth: async () => {
    const refreshToken = getStoredRefreshToken();
    if (!refreshToken) {
      set({ isLoading: false });
      return;
    }

    try {
      const res = await apiClient.post<{
        access_token: string;
        refresh_token?: string;
        user: User;
      }>("/auth/refresh", { refresh_token: refreshToken });

      apiClient.setAccessToken(res.access_token);
      if (res.refresh_token) {
        setStoredRefreshToken(res.refresh_token);
      }
      set({ user: res.user, isAuthenticated: true, isLoading: false });
    } catch {
      setStoredRefreshToken(null);
      apiClient.setAccessToken(null);
      set({ isLoading: false });
    }
  },

  clearError: () => set({ error: null }),
}));
