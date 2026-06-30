"use client";

import { useState, useRef, type KeyboardEvent } from "react";
import { Send, Loader2 } from "lucide-react";
import { cn } from "@/lib/utils";

interface ChatInputProps {
  onSend: (message: string) => void;
  disabled?: boolean;
  placeholder?: string;
}

export function ChatInput({
  onSend,
  disabled = false,
  placeholder = "Type a message...",
}: ChatInputProps) {
  const [input, setInput] = useState("");
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  const handleSend = () => {
    const trimmed = input.trim();
    if (!trimmed || disabled) return;
    onSend(trimmed);
    setInput("");
    if (textareaRef.current) {
      textareaRef.current.style.height = "auto";
    }
  };

  const handleKeyDown = (e: KeyboardEvent<HTMLTextAreaElement>) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  const handleInput = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setInput(e.target.value);
    const textarea = e.target;
    textarea.style.height = "auto";
    textarea.style.height = `${Math.min(textarea.scrollHeight, 200)}px`;
  };

  return (
    <div className="flex items-end gap-2 p-4 border-t border-dark-border bg-dark-bg">
      <div className="flex-1 relative">
        <textarea
          ref={textareaRef}
          value={input}
          onChange={handleInput}
          onKeyDown={handleKeyDown}
          placeholder={placeholder}
          rows={1}
          disabled={disabled}
          className={cn(
            "w-full resize-none rounded-lg bg-dark-input border border-dark-border text-neutral-0 placeholder:text-surface-500 px-4 py-3 pr-12 text-sm",
            "focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-500/30",
            "disabled:opacity-50 disabled:cursor-not-allowed",
            "scrollbar-hide"
          )}
          style={{ maxHeight: "200px" }}
        />
      </div>
      <button
        onClick={handleSend}
        aria-label="Send message"
        disabled={disabled || !input.trim()}
        className={cn(
          "flex-shrink-0 w-10 h-10 rounded-lg flex items-center justify-center transition-colors duration-150",
          input.trim() && !disabled
            ? "bg-primary-500 text-white hover:bg-primary-600"
            : "bg-surface-800 text-surface-500 cursor-not-allowed"
        )}
      >
        {disabled ? (
          <Loader2 size={18} className="animate-spin" aria-hidden={true} />
        ) : (
          <Send size={18} aria-hidden={true} />
        )}
      </button>
    </div>
  );
}
