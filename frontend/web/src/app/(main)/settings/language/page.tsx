"use client";

import { useSettingsStore } from "@/stores/settings-store";
import { SectionHeader } from "@/components/ui/section-header";
import { Card } from "@/components/ui/card";
import { cn } from "@/lib/utils";
import { Check } from "lucide-react";
import type { Language } from "@/types";

const languages: { id: Language; label: string; native: string }[] = [
  { id: "en", label: "English", native: "English" },
  { id: "ar", label: "Arabic", native: "العربية" },
  { id: "fr", label: "French", native: "Français" },
];

export default function LanguagePage() {
  const { language, setLanguage } = useSettingsStore();

  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader title="Language" description="Change your language preference" />
      <div className="space-y-2">
        {languages.map((l) => (
          <button key={l.id} onClick={() => setLanguage(l.id)} className="w-full text-left">
            <Card className={cn(
              "flex items-center gap-4",
              language === l.id && "border-primary-500 ring-1 ring-primary-500/30"
            )}>
              <div className="flex-1">
                <p className="text-sm font-medium text-neutral-0">{l.label}</p>
                <p className="text-xs text-surface-400">{l.native}</p>
              </div>
              {language === l.id && <Check size={18} className="text-primary-400" aria-hidden={true} />}
            </Card>
          </button>
        ))}
      </div>
    </div>
  );
}
