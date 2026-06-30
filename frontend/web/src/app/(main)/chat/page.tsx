"use client";

import { useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { Plus, MessageCircle, Trash2 } from "lucide-react";
import { useChatStore } from "@/stores/chat-store";
import { ChatBubble } from "@/components/ui/chat-bubble";
import { ChatInput } from "@/components/ui/chat-input";
import { TypingIndicator } from "@/components/ui/typing-indicator";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingScreen } from "@/components/ui/loading-screen";
import { formatRelativeTime, cn } from "@/lib/utils";

export default function ChatPage() {
  const router = useRouter();
  const {
    conversations,
    currentConversationId,
    messages,
    isStreaming,
    streamingContent,
    isLoadingMessages,
    isLoadingConversations,
    fetchConversations,
    selectConversation,
    sendMessage,
    createConversation,
    deleteConversation,
  } = useChatStore();

  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    fetchConversations();
  }, [fetchConversations]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, streamingContent]);

  const handleSend = (content: string) => {
    sendMessage({ content, conversation_id: currentConversationId || undefined });
  };

  const handleNewChat = async () => {
    try {
      const id = await createConversation();
      await selectConversation(id);
    } catch {
      // handled in store
    }
  };

  const handleSelectConversation = (id: string) => {
    router.push(`/chat/${id}`);
  };

  if (isLoadingConversations) {
    return (
      <div className="h-full flex">
        <div className="w-80 border-r border-dark-border p-4 space-y-3">
          {[...Array(5)].map((_, i) => (
            <div key={i} className="h-16 rounded-lg bg-surface-800 animate-pulse" />
          ))}
        </div>
        <div className="flex-1 flex items-center justify-center">
          <LoadingScreen />
        </div>
      </div>
    );
  }

  return (
    <div className="h-full flex">
      <div className="w-80 flex-shrink-0 border-r border-dark-border flex flex-col bg-dark-surface hidden md:flex">
        <div className="p-3 border-b border-dark-border">
          <button
            onClick={handleNewChat}
            className="flex items-center justify-center gap-2 w-full h-10 rounded-md bg-primary-500 text-white text-sm font-medium hover:bg-primary-600 transition-colors"
          >
            <Plus size={16} aria-hidden={true} />
            New chat
          </button>
        </div>
        <div className="flex-1 overflow-y-auto p-2 space-y-1">
          {conversations.length === 0 ? (
            <div className="text-center text-surface-500 text-sm py-8">
              No conversations yet
            </div>
          ) : (
            conversations.map((conv) => (
              <button
                key={conv.id}
                onClick={() => handleSelectConversation(conv.id)}
                className={cn(
                  "w-full text-left px-3 py-2.5 rounded-md transition-colors group",
                  conv.id === currentConversationId
                    ? "bg-primary-500/10"
                    : "hover:bg-dark-border"
                )}
              >
                <div className="flex items-start gap-2">
                  <MessageCircle size={16} className="text-surface-400 mt-0.5 flex-shrink-0" aria-hidden={true} />
                  <div className="flex-1 min-w-0">
                    <p className="text-sm text-neutral-0 font-medium truncate">
                      {conv.title}
                    </p>
                    <p className="text-xs text-surface-500 mt-0.5">
                      {formatRelativeTime(conv.updated_at)}
                    </p>
                  </div>
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      deleteConversation(conv.id);
                    }}
                    aria-label="Delete conversation"
                    className="opacity-0 group-hover:opacity-100 text-surface-500 hover:text-error transition-all"
                  >
                    <Trash2 size={14} aria-hidden={true} />
                  </button>
                </div>
              </button>
            ))
          )}
        </div>
      </div>

      <div className="flex-1 flex flex-col min-w-0">
        {messages.length === 0 && !isStreaming ? (
          <div className="flex-1 flex items-center justify-center">
            <EmptyState
              icon={<MessageCircle size={48} aria-hidden={true} />}
              title="Start a conversation"
              description="Send a message to begin chatting with your AI companion"
            />
          </div>
        ) : (
          <div className="flex-1 overflow-y-auto p-4 space-y-4">
            {messages.map((msg) => (
              <ChatBubble
                key={msg.id}
                role={msg.role}
                content={msg.content}
                timestamp={msg.created_at}
              />
            ))}
            {isStreaming && streamingContent && (
              <ChatBubble
                role="assistant"
                content={streamingContent}
                isStreaming
              />
            )}
            {isStreaming && !streamingContent && <TypingIndicator />}
            <div ref={messagesEndRef} />
          </div>
        )}

        <ChatInput onSend={handleSend} disabled={isStreaming} />
      </div>
    </div>
  );
}
