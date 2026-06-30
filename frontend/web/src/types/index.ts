export * from "./api";
export * from "./chat";

export interface User {
  id: string;
  email: string;
  name: string;
  personality: string;
  language: string;
  avatar_url?: string;
  created_at: string;
}

export interface UserProfile {
  name: string;
  email: string;
  bio?: string;
  avatar_url?: string;
  personality: string;
  language: string;
}

export interface MemoryItem {
  id: string;
  content: string;
  category: string;
  importance: number;
  created_at: string;
  updated_at: string;
  tags: string[];
}

export interface Personality {
  id: string;
  name: string;
  description: string;
  traits: string[];
  is_active: boolean;
  created_at: string;
}

export interface Notification {
  id: string;
  title: string;
  message: string;
  type: "info" | "warning" | "success" | "error";
  read: boolean;
  created_at: string;
}

export interface DashboardStats {
  total_conversations: number;
  total_messages: number;
  total_memories: number;
  active_days: number;
  words_learned: number;
  conversations_this_week: number;
}

export type ThemeMode = "dark" | "light" | "amoled";
export type Language = "en" | "ar" | "fr";

export type SidebarView = "chat" | "memory" | "profile" | "settings";

export interface Settings {
  theme: ThemeMode;
  language: Language;
  notificationsEnabled: boolean;
  messageNotifications: boolean;
  memoryNotifications: boolean;
  weeklyReport: boolean;
  autoDeleteConversations: boolean;
  autoDeleteDays: number;
  shareUsageData: boolean;
  developerMode: boolean;
}
