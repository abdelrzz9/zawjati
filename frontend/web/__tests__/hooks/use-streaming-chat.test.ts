import { describe, it, expect, vi, beforeEach } from "vitest";
import { renderHook, act, waitFor } from "@testing-library/react";
import { useStreamingChat } from "@/hooks/use-streaming-chat";
import { apiClient } from "@/lib/api-client";

vi.mock("@/lib/api-client", () => ({
  apiClient: {
    streamChat: vi.fn(),
  },
}));

describe("useStreamingChat", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("returns initial state", () => {
    const { result } = renderHook(() => useStreamingChat());
    expect(result.current.isStreaming).toBe(false);
    expect(result.current.content).toBe("");
  });

  it("accumulates streaming content", async () => {
    const mockStream = (async function* () {
      yield "Hello ";
      yield "World";
    })();
    vi.mocked(apiClient.streamChat).mockReturnValueOnce(mockStream);

    const { result } = renderHook(() => useStreamingChat());

    const onDone = vi.fn();

    act(() => {
      result.current.startStream("Hi", {
        conversationId: "conv-1",
        onDone,
      });
    });

    await waitFor(() => {
      expect(result.current.content).toBe("Hello World");
    });

    await waitFor(() => {
      expect(result.current.isStreaming).toBe(false);
    });

    expect(onDone).toHaveBeenCalled();
  });

  it("stops streaming on abort", async () => {
    const mockStream = (async function* () {
      yield "Partial";
      await new Promise((r) => setTimeout(r, 100));
      yield "More";
    })();
    vi.mocked(apiClient.streamChat).mockReturnValueOnce(mockStream);

    const { result } = renderHook(() => useStreamingChat());

    act(() => {
      result.current.startStream("Hi", {
        conversationId: "conv-1",
      });
    });

    act(() => {
      result.current.stopStream();
    });

    await waitFor(() => {
      expect(result.current.isStreaming).toBe(false);
    });
  });

  it("handles stream errors", async () => {
    vi.mocked(apiClient.streamChat).mockRejectedValueOnce(new Error("Stream failed"));

    const { result } = renderHook(() => useStreamingChat());

    const onError = vi.fn();

    act(() => {
      result.current.startStream("Hi", {
        conversationId: "conv-1",
        onError,
      });
    });

    await waitFor(() => {
      expect(result.current.isStreaming).toBe(false);
    });
  });
});
