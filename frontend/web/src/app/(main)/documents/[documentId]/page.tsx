"use client";

import { useParams, useRouter } from "next/navigation";
import { ArrowLeft, FileText, Download, Trash2 } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { SectionHeader } from "@/components/ui/section-header";
import { showSuccess } from "@/components/ui/snackbar";

export default function DocumentDetailPage() {
  const params = useParams();
  const router = useRouter();

  return (
    <div className="max-w-3xl mx-auto p-4 md:p-6 space-y-6">
      <div className="flex items-center gap-3">
        <button onClick={() => router.push("/documents")} aria-label="Go back" className="text-surface-400 hover:text-neutral-0">
          <ArrowLeft size={20} aria-hidden={true} />
        </button>
        <SectionHeader title="Document Details" />
      </div>

      <Card>
        <CardContent className="space-y-4">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 rounded-xl bg-primary-500/10 flex items-center justify-center">
              <FileText size={32} className="text-primary-400" aria-hidden={true} />
            </div>
            <div>
              <h2 className="text-lg font-semibold text-neutral-0">Document</h2>
              <p className="text-sm text-surface-400">Document ID: {params.documentId}</p>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4 pt-4 border-t border-dark-border">
            <div>
              <p className="text-xs text-surface-500">Type</p>
              <p className="text-sm text-neutral-0">PDF</p>
            </div>
            <div>
              <p className="text-xs text-surface-500">Size</p>
              <p className="text-sm text-neutral-0">2.4 MB</p>
            </div>
            <div>
              <p className="text-xs text-surface-500">Pages</p>
              <p className="text-sm text-neutral-0">12</p>
            </div>
            <div>
              <p className="text-xs text-surface-500">Uploaded</p>
              <p className="text-sm text-neutral-0">March 15, 2024</p>
            </div>
          </div>

          <div className="flex gap-2 pt-4 border-t border-dark-border">
            <Button variant="secondary" size="sm" icon={<Download size={14} aria-hidden={true} />}>
              Download
            </Button>
            <Button variant="danger" size="sm" icon={<Trash2 size={14} aria-hidden={true} />}>
              Delete
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
