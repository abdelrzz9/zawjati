"use client";

import { useSettingsStore } from "@/stores/settings-store";
import { SectionHeader } from "@/components/ui/section-header";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { showSuccess } from "@/components/ui/snackbar";
import { HardDrive, Trash2 } from "lucide-react";

export default function StoragePage() {
  const { autoDeleteConversations, autoDeleteDays, setAutoDeleteConversations, setAutoDeleteDays } = useSettingsStore();

  const handleClearAll = () => {
    showSuccess("All data cleared");
  };

  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader title="Storage" description="Manage data and storage" />

      <Card>
        <CardContent className="space-y-4">
          <div className="flex items-center gap-3">
            <HardDrive size={20} className="text-surface-400" aria-hidden={true} />
            <div className="flex-1">
              <p className="text-sm text-neutral-0">Storage used</p>
              <div className="w-full h-2 rounded-full bg-surface-800 mt-2">
                <div className="w-1/3 h-full rounded-full bg-primary-500" />
              </div>
            </div>
            <span className="text-sm text-surface-400">1.2 GB / 5 GB</span>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-neutral-0">Auto-delete conversations</p>
              <p className="text-xs text-surface-400">Automatically delete conversations older than</p>
            </div>
            <button
              onClick={() => setAutoDeleteConversations(!autoDeleteConversations)}
              className={`relative w-11 h-6 rounded-full transition-colors ${
                autoDeleteConversations ? "bg-primary-500" : "bg-surface-700"
              }`}
            >
              <span className={`block w-4 h-4 bg-white rounded-full transition-transform mt-0.5 ml-0.5 ${
                autoDeleteConversations ? "translate-x-5.5" : "translate-x-0"
              }`} />
            </button>
          </div>
          {autoDeleteConversations && (
            <Input
              type="number"
              label="Delete after (days)"
              value={autoDeleteDays}
              onChange={(e) => setAutoDeleteDays(parseInt(e.target.value) || 30)}
            />
          )}
        </CardContent>
      </Card>

      <Card>
        <CardContent className="space-y-4">
          <p className="text-sm font-medium text-neutral-0">Clear all data</p>
          <p className="text-xs text-surface-400">This will delete all conversations, memories, and preferences</p>
          <Button variant="danger" icon={<Trash2 size={16} aria-hidden={true} />} onClick={handleClearAll}>
            Clear everything
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
