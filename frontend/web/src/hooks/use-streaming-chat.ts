"use client";

import { useState, useRef, useCallback } from "react";
import { apiClient } from "@/lib/api-client";

interface UseStreamingChatOptions {
  conversationId: string;
  onToken?: (token: string) => void;
  onDone?: () => void;
  onError?: (error: Error) => void;
}

export function useStreamingChat() {
  const [isStreaming, setIsStreaming] = useState(false);
  const [content, setContent] = useState("");
  const abortRef = useRef<AbortController | null>(null);

  const startStream = useCallback(
    async (message: string, options: UseStreamingChatOptions) => {
      const { conversationId, onToken, onDone, onError } = options;
      setIsStreaming(true);
      setContent("");

      abortRef.current = new AbortController();

      try {
        let fullContent = "";
        const stream = apiClient.streamChat(
          `/chat/conversations/${conversationId}/messages`,
          { content: message }
        );

        for await (const token of stream) {
          if (abortRef.current?.signal.aborted) break;
          fullContent += token;
          setContent(fullContent);
          onToken?.(token);
        }

        if (!abortRef.current?.signal.aborted) {
          setIsStreaming(false);
          onDone?.();
        }
      } catch (error) {
        if (error instanceof Error && error.name !== "AbortError") {
          setIsStreaming(false);
          onError?.(error);
        }
      }
    },
    []
  );

  const stopStream = useCallback(() => {
    abortRef.current?.abort();
    setIsStreaming(false);
  }, []);

  return { isStreaming, content, startStream, stopStream };
}
