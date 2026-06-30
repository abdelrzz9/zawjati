"use client";

import { useSettingsStore } from "@/stores/settings-store";
import { SectionHeader } from "@/components/ui/section-header";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { showSuccess } from "@/components/ui/snackbar";
import { Download, Trash2 } from "lucide-react";

export default function PrivacyPage() {
  const { shareUsageData, setShareUsageData } = useSettingsStore();

  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader title="Privacy" description="Control your privacy settings" />

      <Card>
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm font-medium text-neutral-0">Share usage data</p>
            <p className="text-xs text-surface-400">Help improve Zawjati by sharing anonymous usage data</p>
          </div>
          <button
            onClick={() => setShareUsageData(!shareUsageData)}
            className={`relative w-11 h-6 rounded-full transition-colors ${
              shareUsageData ? "bg-primary-500" : "bg-surface-700"
            }`}
          >
            <span className={`block w-4 h-4 bg-white rounded-full transition-transform mt-0.5 ml-0.5 ${
              shareUsageData ? "translate-x-5.5" : "translate-x-0"
            }`} />
          </button>
        </div>
      </Card>

      <Card>
        <div className="space-y-3">
          <p className="text-sm font-medium text-neutral-0">Data management</p>
          <div className="flex flex-col gap-2">
            <Button variant="secondary" icon={<Download size={16} aria-hidden={true} />}>
              Export my data
            </Button>
            <Button variant="danger" icon={<Trash2 size={16} aria-hidden={true} />}>
              Delete my account
            </Button>
          </div>
        </div>
      </Card>
    </div>
  );
}
