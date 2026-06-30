"use client";

import { useSettingsStore } from "@/stores/settings-store";
import { SectionHeader } from "@/components/ui/section-header";
import { Card } from "@/components/ui/card";
import { cn } from "@/lib/utils";
import { Sun, Moon, Monitor } from "lucide-react";
import type { ThemeMode } from "@/types";

const themes: { id: ThemeMode; label: string; description: string; icon: typeof Sun }[] = [
  { id: "dark", label: "Dark", description: "Easy on the eyes", icon: Moon },
  { id: "light", label: "Light", description: "Bright and clean", icon: Sun },
  { id: "amoled", label: "AMOLED", description: "True blacks for OLED screens", icon: Monitor },
];

export default function ThemePage() {
  const { theme, setTheme } = useSettingsStore();

  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader title="Theme" description="Customize your appearance" />
      <div className="grid grid-cols-3 gap-3">
        {themes.map((t) => {
          const Icon = t.icon;
          const isActive = theme === t.id;
          return (
            <button key={t.id} onClick={() => setTheme(t.id)} className="text-left">
              <Card className={cn(
                "text-center p-6 transition-all",
                isActive && "border-primary-500 ring-1 ring-primary-500/30"
              )}>
                <div className={cn(
                  "w-12 h-12 rounded-xl flex items-center justify-center mx-auto mb-3",
                  isActive ? "bg-primary-500/20 text-primary-400" : "bg-dark-surface text-surface-400"
                )}>
                  <Icon size={22} aria-hidden={true} />
                </div>
                <p className="text-sm font-medium text-neutral-0">{t.label}</p>
                <p className="text-xs text-surface-400 mt-1">{t.description}</p>
              </Card>
            </button>
          );
        })}
      </div>
    </div>
  );
}
