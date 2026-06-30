import { describe, it, expect, vi, beforeEach } from "vitest";
import { useChatStore } from "@/stores/chat-store";
import { apiClient } from "@/lib/api-client";

vi.mock("@/lib/api-client", () => ({
  apiClient: {
    get: vi.fn(),
    post: vi.fn(),
    delete: vi.fn(),
    streamChat: vi.fn(),
    setAccessToken: vi.fn(),
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
  useChatStore.setState({
    conversations: [],
    currentConversationId: null,
    messages: [],
    isLoadingConversations: false,
    isLoadingMessages: false,
    isStreaming: false,
    streamingContent: "",
    error: null,
  });
});

describe("ChatStore", () => {
  describe("fetchConversations", () => {
    it("loads conversations successfully", async () => {
      const mockConversations = [
        { id: "1", title: "Chat 1", updated_at: "2024-01-01" },
      ];
      vi.mocked(apiClient.get).mockResolvedValueOnce(mockConversations);

      await useChatStore.getState().fetchConversations();

      const state = useChatStore.getState();
      expect(state.conversations).toEqual(mockConversations);
      expect(state.isLoadingConversations).toBe(false);
    });

    it("sets error on failure", async () => {
      vi.mocked(apiClient.get).mockRejectedValueOnce(new Error("Failed"));

      await useChatStore.getState().fetchConversations();

      const state = useChatStore.getState();
      expect(state.error).toBeTruthy();
      expect(state.isLoadingConversations).toBe(false);
    });
  });

  describe("sendMessage", () => {
    it("creates conversation and sends message", async () => {
      vi.mocked(apiClient.post).mockResolvedValueOnce({ id: "new-conv" });
      vi.mocked(apiClient.get).mockResolvedValueOnce([]);

      const mockStream = (async function* () {
        yield "Hello";
        yield " World";
      })();
      vi.mocked(apiClient.streamChat).mockReturnValueOnce(mockStream);

      await useChatStore.getState().sendMessage({ content: "Hi" });

      const state = useChatStore.getState();
      expect(state.messages.length).toBeGreaterThanOrEqual(1);
      expect(state.isStreaming).toBe(false);
    });
  });

  describe("deleteConversation", () => {
    it("removes conversation from list", async () => {
      vi.mocked(apiClient.delete).mockResolvedValueOnce({});

      useChatStore.setState({
        conversations: [{ id: "1", title: "Test", updated_at: "2024-01-01" }],
      });

      await useChatStore.getState().deleteConversation("1");

      const state = useChatStore.getState();
      expect(state.conversations).toHaveLength(0);
    });
  });

  describe("selectConversation", () => {
    it("loads messages for conversation", async () => {
      const mockMessages = [
        { id: "m1", content: "Hello", role: "user", created_at: "2024-01-01" },
      ];
      vi.mocked(apiClient.get).mockResolvedValueOnce(mockMessages);

      await useChatStore.getState().selectConversation("conv-1");

      const state = useChatStore.getState();
      expect(state.currentConversationId).toBe("conv-1");
      expect(state.messages).toEqual(mockMessages);
    });
  });
});
