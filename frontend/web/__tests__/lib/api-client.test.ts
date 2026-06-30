import { describe, it, expect, vi, beforeEach } from "vitest";
import { apiClient, ApiError } from "@/lib/api-client";

const mockFetch = vi.fn();
global.fetch = mockFetch;

beforeEach(() => {
  mockFetch.mockReset();
  apiClient.setAccessToken(null);
});

describe("ApiClient", () => {
  describe("get", () => {
    it("makes GET request and returns JSON", async () => {
      mockFetch.mockResolvedValueOnce({
        ok: true,
        json: () => Promise.resolve({ data: "test" }),
      });

      const result = await apiClient.get("/test");
      expect(result).toEqual({ data: "test" });
      expect(mockFetch).toHaveBeenCalledWith(
        expect.stringContaining("/api/test"),
        expect.objectContaining({
          headers: expect.objectContaining({ "Content-Type": "application/json" }),
        }),
      );
    });

    it("includes Authorization header when token is set", async () => {
      apiClient.setAccessToken("test-token");
      mockFetch.mockResolvedValueOnce({
        ok: true,
        json: () => Promise.resolve({}),
      });

      await apiClient.get("/protected");
      expect(mockFetch).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({
          headers: expect.objectContaining({
            Authorization: "Bearer test-token",
          }),
        }),
      );
    });

    it("throws ApiError on non-ok response", async () => {
      mockFetch.mockResolvedValueOnce({
        ok: false,
        status: 404,
        json: () => Promise.resolve({ message: "Not found" }),
      });

      await expect(apiClient.get("/not-found")).rejects.toThrow(ApiError);
    });
  });

  describe("post", () => {
    it("makes POST request with body", async () => {
      mockFetch.mockResolvedValueOnce({
        ok: true,
        json: () => Promise.resolve({ id: "123" }),
      });

      const result = await apiClient.post("/create", { name: "test" });
      expect(result).toEqual({ id: "123" });
      expect(mockFetch).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({
          method: "POST",
          body: JSON.stringify({ name: "test" }),
        }),
      );
    });

    it("throws on server error", async () => {
      mockFetch.mockResolvedValueOnce({
        ok: false,
        status: 500,
        json: () => Promise.resolve({ message: "Server error" }),
      });

      await expect(apiClient.post("/error")).rejects.toThrow(ApiError);
    });
  });

  describe("streamChat", () => {
    it("yields tokens from SSE stream", async () => {
      const encoder = new TextEncoder();
      const stream = new ReadableStream({
        start(controller) {
          controller.enqueue(encoder.encode('data: {"token":"Hello"}\n\n'));
          controller.enqueue(encoder.encode('data: {"token":" World"}\n\n'));
          controller.close();
        },
      });

      mockFetch.mockResolvedValueOnce({
        ok: true,
        body: stream,
      });

      const tokens: string[] = [];
      for await (const token of apiClient.streamChat("/stream", {})) {
        tokens.push(token);
      }

      expect(tokens).toEqual(["Hello", " World"]);
    });

    it("handles stream errors", async () => {
      mockFetch.mockResolvedValueOnce({
        ok: false,
        status: 500,
        json: () => Promise.resolve({ message: "Stream failed" }),
      });

      const stream = apiClient.streamChat("/stream", {});
      await expect(stream.next()).rejects.toThrow(ApiError);
    });
  });
});
