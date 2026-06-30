"use client";

import { motion } from "framer-motion";
import { Bot, User } from "lucide-react";
import { cn } from "@/lib/utils";
import { MarkdownView } from "./markdown-view";
import type { MessageRole } from "@/types";

interface ChatBubbleProps {
  role: MessageRole;
  content: string;
  timestamp?: string;
  isStreaming?: boolean;
}

export function ChatBubble({ role, content, timestamp, isStreaming }: ChatBubbleProps) {
  const isUser = role === "user";

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className={cn("flex gap-3 w-full", isUser ? "justify-end" : "justify-start")}
    >
      {!isUser && (
        <div className="flex-shrink-0 w-8 h-8 rounded-full bg-primary-500/20 flex items-center justify-center mt-1">
          <Bot size={16} className="text-primary-400" aria-hidden={true} />
        </div>
      )}

      <div
        className={cn(
          "max-w-[80%] rounded-2xl px-4 py-3",
          isUser
            ? "bg-primary-500 text-white rounded-tr-sm"
            : "bg-dark-surface border border-dark-border rounded-tl-sm"
        )}
      >
        {isUser ? (
          <p className="text-sm leading-relaxed whitespace-pre-wrap">{content}</p>
        ) : (
          <div className="text-sm leading-relaxed">
            <MarkdownView content={content} />
            {isStreaming && (
              <span className="inline-block w-2 h-4 bg-primary-400 animate-pulse ml-1" />
            )}
          </div>
        )}
        {timestamp && (
          <p
            className={cn(
              "text-xs mt-1",
              isUser ? "text-white/60" : "text-surface-500"
            )}
          >
            {new Date(timestamp).toLocaleTimeString([], {
              hour: "2-digit",
              minute: "2-digit",
            })}
          </p>
        )}
      </div>

      {isUser && (
        <div className="flex-shrink-0 w-8 h-8 rounded-full bg-primary-500 flex items-center justify-center mt-1">
          <User size={16} className="text-white" aria-hidden={true} />
        </div>
      )}
    </motion.div>
  );
}
