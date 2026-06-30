"use client";

import { useSettingsStore } from "@/stores/settings-store";
import { SectionHeader } from "@/components/ui/section-header";
import { Card } from "@/components/ui/card";

const toggleItems = [
  { key: "notificationsEnabled" as const, label: "Enable notifications", description: "Receive notifications from Zawjati" },
  { key: "messageNotifications" as const, label: "Message notifications", description: "Get notified when you receive a new message" },
  { key: "memoryNotifications" as const, label: "Memory notifications", description: "Get notified when new memories are created" },
  { key: "weeklyReport" as const, label: "Weekly report", description: "Receive a weekly summary of your activity" },
];

export default function NotificationsPage() {
  const settings = useSettingsStore();

  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader title="Notifications" description="Manage notification preferences" />
      <div className="space-y-2">
        {toggleItems.map((item) => (
          <Card key={item.key}>
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-neutral-0">{item.label}</p>
                <p className="text-xs text-surface-400">{item.description}</p>
              </div>
              <button
                aria-label={`Toggle ${item.label}`}
                onClick={() => {
                  const setter = `set${item.key.charAt(0).toUpperCase() + item.key.slice(1)}` as keyof typeof settings;
                  (settings[setter] as (v: boolean) => void)(!settings[item.key]);
                }}
                className={`relative w-11 h-6 rounded-full transition-colors ${
                  settings[item.key] ? "bg-primary-500" : "bg-surface-700"
                }`}
              >
                <span
                  className={`block w-4 h-4 bg-white rounded-full transition-transform mt-0.5 ml-0.5 ${
                    settings[item.key] ? "translate-x-5.5" : "translate-x-0"
                  }`}
                />
              </button>
            </div>
          </Card>
        ))}
      </div>
    </div>
  );
}
