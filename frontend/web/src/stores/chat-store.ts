import { create } from "zustand";
import { apiClient, ApiError } from "@/lib/api-client";
import type { Conversation, Message, ChatInput } from "@/types";

interface ChatState {
  conversations: Conversation[];
  currentConversationId: string | null;
  messages: Message[];
  isLoadingConversations: boolean;
  isLoadingMessages: boolean;
  isStreaming: boolean;
  streamingContent: string;
  error: string | null;

  fetchConversations: () => Promise<void>;
  createConversation: () => Promise<string>;
  selectConversation: (id: string) => Promise<void>;
  sendMessage: (input: ChatInput) => Promise<void>;
  deleteConversation: (id: string) => Promise<void>;
  clearError: () => void;
}

export const useChatStore = create<ChatState>((set, get) => ({
  conversations: [],
  currentConversationId: null,
  messages: [],
  isLoadingConversations: false,
  isLoadingMessages: false,
  isStreaming: false,
  streamingContent: "",
  error: null,

  fetchConversations: async () => {
    set({ isLoadingConversations: true, error: null });
    try {
      const data = await apiClient.get<Conversation[]>("/chat/conversations");
      set({ conversations: data, isLoadingConversations: false });
    } catch (e) {
      set({
        error: e instanceof ApiError ? e.message : "Failed to load conversations",
        isLoadingConversations: false,
      });
    }
  },

  createConversation: async () => {
    try {
      const data = await apiClient.post<{ id: string; title: string }>("/chat/conversations", { title: "New conversation" });
      await get().fetchConversations();
      return data.id;
    } catch (e) {
      set({ error: e instanceof ApiError ? e.message : "Failed to create conversation" });
      throw e;
    }
  },

  selectConversation: async (id: string) => {
    set({ isLoadingMessages: true, currentConversationId: id, error: null });
    try {
      const messages = await apiClient.get<Message[]>(`/chat/conversations/${id}/messages`);
      set({ messages, isLoadingMessages: false });
    } catch (e) {
      set({
        error: e instanceof ApiError ? e.message : "Failed to load messages",
        isLoadingMessages: false,
      });
    }
  },

  sendMessage: async (input: ChatInput) => {
    const { currentConversationId, messages } = get();
    let convId = input.conversation_id || currentConversationId;

    if (!convId) {
      try {
        convId = await get().createConversation();
      } catch {
        return;
      }
    }

    const userMessage: Message = {
      id: `temp-${Date.now()}`,
      conversation_id: convId,
      role: "user",
      content: input.content,
      created_at: new Date().toISOString(),
    };

    set({
      messages: [...messages, userMessage],
      isStreaming: true,
      streamingContent: "",
      currentConversationId: convId,
    });

    try {
      let fullContent = "";
      const stream = apiClient.streamChat(`/chat/conversations/${convId}/messages`, {
        content: input.content,
      });

      for await (const token of stream) {
        fullContent += token;
        set({ streamingContent: fullContent, isStreaming: true });
      }

      const assistantMessage: Message = {
        id: `msg-${Date.now()}`,
        conversation_id: convId,
        role: "assistant",
        content: fullContent,
        created_at: new Date().toISOString(),
      };

      set((state) => ({
        messages: [...state.messages, assistantMessage],
        isStreaming: false,
        streamingContent: "",
      }));

      get().fetchConversations();
    } catch (e) {
      set({
        isStreaming: false,
        streamingContent: "",
        error: e instanceof ApiError ? e.message : "Failed to send message",
      });
    }
  },

  deleteConversation: async (id: string) => {
    try {
      await apiClient.delete(`/chat/conversations/${id}`);
      const { currentConversationId, conversations } = get();
      set({
        conversations: conversations.filter((c) => c.id !== id),
        currentConversationId: currentConversationId === id ? null : currentConversationId,
        messages: currentConversationId === id ? [] : get().messages,
      });
    } catch (e) {
      set({ error: e instanceof ApiError ? e.message : "Failed to delete conversation" });
    }
  },

  clearError: () => set({ error: null }),
}));
