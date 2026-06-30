"use client";

import Link from "next/link";
import {
  Palette,
  Globe,
  Bell,
  HardDrive,
  Shield,
  Code,
  ChevronRight,
} from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { SectionHeader } from "@/components/ui/section-header";

const settingsItems = [
  { href: "/settings/theme", label: "Theme", description: "Customize your appearance", icon: Palette, color: "text-primary-400" },
  { href: "/settings/language", label: "Language", description: "Change your language preference", icon: Globe, color: "text-blue-400" },
  { href: "/settings/notifications", label: "Notifications", description: "Manage notification preferences", icon: Bell, color: "text-amber-400" },
  { href: "/settings/storage", label: "Storage", description: "Manage data and storage", icon: HardDrive, color: "text-emerald-400" },
  { href: "/settings/privacy", label: "Privacy", description: "Control your privacy settings", icon: Shield, color: "text-rose-400" },
  { href: "/settings/developer", label: "Developer", description: "API keys and developer options", icon: Code, color: "text-purple-400" },
];

export default function SettingsPage() {
  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader title="Settings" description="Manage your preferences" />

      <div className="space-y-2">
        {settingsItems.map((item) => {
          const Icon = item.icon;
          return (
            <Link key={item.href} href={item.href}>
              <Card variant="interactive">
                <CardContent>
                  <div className="flex items-center gap-4">
                    <div className={`w-10 h-10 rounded-lg bg-dark-surface flex items-center justify-center ${item.color}`}>
                      <Icon size={20} aria-hidden={true} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium text-neutral-0">{item.label}</p>
                      <p className="text-xs text-surface-400">{item.description}</p>
                    </div>
                    <ChevronRight size={18} className="text-surface-500" aria-hidden={true} />
                  </div>
                </CardContent>
              </Card>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
