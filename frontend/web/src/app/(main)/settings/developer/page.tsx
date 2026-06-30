"use client";

import { useState } from "react";
import { useSettingsStore } from "@/stores/settings-store";
import { SectionHeader } from "@/components/ui/section-header";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { showSuccess } from "@/components/ui/snackbar";
import { Code, Copy, Eye, EyeOff, Plus, Trash2 } from "lucide-react";

interface ApiKey {
  id: string;
  name: string;
  key: string;
  created: string;
}

export default function DeveloperPage() {
  const { developerMode, setDeveloperMode } = useSettingsStore();
  const [showKeys, setShowKeys] = useState<Record<string, boolean>>({});

  const [apiKeys] = useState<ApiKey[]>([
    { id: "1", name: "Production", key: "zwj_sk_prod_••••••••••••••••", created: "2024-01-15" },
    { id: "2", name: "Development", key: "zwj_sk_dev_••••••••••••••••", created: "2024-03-20" },
  ]);

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text);
    showSuccess("Copied to clipboard");
  };

  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader title="Developer" description="API keys and developer options" />

      <Card>
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm font-medium text-neutral-0">Developer mode</p>
            <p className="text-xs text-surface-400">Enable developer features and API access</p>
          </div>
          <button
            onClick={() => setDeveloperMode(!developerMode)}
            className={`relative w-11 h-6 rounded-full transition-colors ${
              developerMode ? "bg-primary-500" : "bg-surface-700"
            }`}
          >
            <span className={`block w-4 h-4 bg-white rounded-full transition-transform mt-0.5 ml-0.5 ${
              developerMode ? "translate-x-5.5" : "translate-x-0"
            }`} />
          </button>
        </div>
      </Card>

      {developerMode && (
        <>
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-sm font-medium text-neutral-0">API Keys</h3>
              <p className="text-xs text-surface-400">Manage your API keys for programmatic access</p>
            </div>
            <Button size="sm" icon={<Plus size={14} />}>
              Create key
            </Button>
          </div>

          <div className="space-y-2">
            {apiKeys.map((apiKey) => (
              <Card key={apiKey.id}>
                <CardContent>
                  <div className="flex items-center justify-between mb-2">
                    <p className="text-sm font-medium text-neutral-0">{apiKey.name}</p>
                    <div className="flex items-center gap-1">
                      <button
                        onClick={() => setShowKeys((prev) => ({ ...prev, [apiKey.id]: !prev[apiKey.id] }))}
                        aria-label={showKeys[apiKey.id] ? "Hide key" : "Show key"}
                        className="p-1.5 text-surface-400 hover:text-neutral-0 rounded"
                      >
                        {showKeys[apiKey.id] ? <EyeOff size={14} aria-hidden={true} /> : <Eye size={14} aria-hidden={true} />}
                      </button>
                      <button
                        onClick={() => copyToClipboard(apiKey.key)}
                        aria-label="Copy to clipboard"
                        className="p-1.5 text-surface-400 hover:text-neutral-0 rounded"
                      >
                        <Copy size={14} aria-hidden={true} />
                      </button>
                      <button aria-label="Delete API key" className="p-1.5 text-surface-400 hover:text-error rounded">
                        <Trash2 size={14} aria-hidden={true} />
                      </button>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <Code size={14} className="text-surface-500" aria-hidden={true} />
                    <code className="text-xs text-surface-400 font-mono">
                      {showKeys[apiKey.id] ? apiKey.key : apiKey.key.replace(/[^-]/g, "•")}
                    </code>
                  </div>
                  <p className="text-xs text-surface-500 mt-1">Created: {apiKey.created}</p>
                </CardContent>
              </Card>
            ))}
          </div>

          <Card>
            <CardContent>
              <p className="text-sm font-medium text-neutral-0 mb-2">API Documentation</p>
              <p className="text-xs text-surface-400 mb-3">
                Integrate Zawjati into your own applications using our REST API.
              </p>
              <Button variant="secondary" size="sm">
                View documentation
              </Button>
            </CardContent>
          </Card>
        </>
      )}
    </div>
  );
}
