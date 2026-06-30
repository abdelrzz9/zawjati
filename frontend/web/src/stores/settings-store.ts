import { create } from "zustand";
import { persist } from "zustand/middleware";
import type { ThemeMode, Language, Settings } from "@/types";

interface SettingsState extends Settings {
  setTheme: (theme: ThemeMode) => void;
  setLanguage: (lang: Language) => void;
  setNotificationsEnabled: (enabled: boolean) => void;
  setMessageNotifications: (enabled: boolean) => void;
  setMemoryNotifications: (enabled: boolean) => void;
  setWeeklyReport: (enabled: boolean) => void;
  setAutoDeleteConversations: (enabled: boolean) => void;
  setAutoDeleteDays: (days: number) => void;
  setShareUsageData: (enabled: boolean) => void;
  setDeveloperMode: (enabled: boolean) => void;
  resetSettings: () => void;
}

const defaults: Settings = {
  theme: "dark",
  language: "en",
  notificationsEnabled: true,
  messageNotifications: true,
  memoryNotifications: true,
  weeklyReport: false,
  autoDeleteConversations: false,
  autoDeleteDays: 30,
  shareUsageData: true,
  developerMode: false,
};

export const useSettingsStore = create<SettingsState>()(
  persist(
    (set) => ({
      ...defaults,

      setTheme: (theme) => set({ theme }),
      setLanguage: (language) => set({ language }),
      setNotificationsEnabled: (notificationsEnabled) => set({ notificationsEnabled }),
      setMessageNotifications: (messageNotifications) => set({ messageNotifications }),
      setMemoryNotifications: (memoryNotifications) => set({ memoryNotifications }),
      setWeeklyReport: (weeklyReport) => set({ weeklyReport }),
      setAutoDeleteConversations: (autoDeleteConversations) => set({ autoDeleteConversations }),
      setAutoDeleteDays: (autoDeleteDays) => set({ autoDeleteDays }),
      setShareUsageData: (shareUsageData) => set({ shareUsageData }),
      setDeveloperMode: (developerMode) => set({ developerMode }),
      resetSettings: () => set(defaults),
    }),
    { name: "zawjati-settings" }
  )
);
