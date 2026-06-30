export interface Conversation {
  id: string;
  title: string;
  created_at: string;
  updated_at: string;
  message_count: number;
  preview?: string;
}

export type MessageRole = "user" | "assistant" | "system";

export interface Message {
  id: string;
  conversation_id: string;
  role: MessageRole;
  content: string;
  created_at: string;
  metadata?: MessageMetadata;
}

export interface MessageMetadata {
  sources?: Source[];
  model?: string;
  latency_ms?: number;
  tokens_used?: number;
}

export interface Source {
  title: string;
  url?: string;
  snippet: string;
}

export interface StreamingMessage {
  conversation_id: string;
  token: string;
  done: boolean;
  message_id?: string;
}

export interface ChatInput {
  content: string;
  conversation_id?: string;
}
