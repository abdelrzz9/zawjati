"use client";

import { useEffect, useRef } from "react";
import { useParams, useRouter } from "next/navigation";
import { ArrowLeft, Trash2, MessageCircle } from "lucide-react";
import { useChatStore } from "@/stores/chat-store";
import { ChatBubble } from "@/components/ui/chat-bubble";
import { ChatInput } from "@/components/ui/chat-input";
import { TypingIndicator } from "@/components/ui/typing-indicator";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingScreen } from "@/components/ui/loading-screen";
import { Button } from "@/components/ui/button";

export default function ConversationPage() {
  const params = useParams();
  const router = useRouter();
  const conversationId = params.conversationId as string;
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const {
    messages,
    currentConversationId,
    isStreaming,
    streamingContent,
    isLoadingMessages,
    selectConversation,
    sendMessage,
    deleteConversation,
  } = useChatStore();

  useEffect(() => {
    if (conversationId) {
      selectConversation(conversationId);
    }
  }, [conversationId, selectConversation]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, streamingContent]);

  const handleSend = (content: string) => {
    sendMessage({ content, conversation_id: conversationId });
  };

  const handleDelete = async () => {
    await deleteConversation(conversationId);
    router.push("/chat");
  };

  if (isLoadingMessages) {
    return (
      <div className="h-full flex items-center justify-center">
        <LoadingScreen />
      </div>
    );
  }

  return (
    <div className="h-full flex flex-col">
      <header className="flex items-center gap-3 px-4 py-3 border-b border-dark-border bg-dark-surface">
        <button
          onClick={() => router.push("/chat")}
          aria-label="Go back"
          className="text-surface-400 hover:text-neutral-0 transition-colors"
        >
          <ArrowLeft size={20} aria-hidden={true} />
        </button>
        <div className="flex-1">
          <h1 className="text-sm font-medium text-neutral-0">Conversation</h1>
          <p className="text-xs text-surface-500">{messages.length} messages</p>
        </div>
        <button
          onClick={handleDelete}
          aria-label="Delete conversation"
          className="text-surface-400 hover:text-error transition-colors"
        >
          <Trash2 size={18} aria-hidden={true} />
        </button>
      </header>

      {messages.length === 0 && !isStreaming ? (
        <div className="flex-1 flex items-center justify-center">
          <EmptyState
            icon={<MessageCircle size={48} aria-hidden={true} />}
            title="Send a message"
            description="Start the conversation with your AI companion"
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
  );
}
