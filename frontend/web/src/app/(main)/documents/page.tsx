"use client";

import { useState } from "react";
import Link from "next/link";
import { motion } from "framer-motion";
import { FileText, Upload, File, MoreHorizontal } from "lucide-react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { SearchInput } from "@/components/ui/search-input";
import { SectionHeader } from "@/components/ui/section-header";
import { EmptyState } from "@/components/ui/empty-state";
import { formatRelativeTime } from "@/lib/utils";

interface Document {
  id: string;
  title: string;
  type: string;
  size: string;
  uploaded_at: string;
}

const documents: Document[] = [
  { id: "1", title: "Meeting notes - Q1 2024", type: "PDF", size: "2.4 MB", uploaded_at: new Date(Date.now() - 86400000).toISOString() },
  { id: "2", title: "Project requirements", type: "DOCX", size: "1.1 MB", uploaded_at: new Date(Date.now() - 172800000).toISOString() },
  { id: "3", title: "Research paper draft", type: "TXT", size: "45 KB", uploaded_at: new Date(Date.now() - 259200000).toISOString() },
];

export default function DocumentsPage() {
  const [search, setSearch] = useState("");

  const filtered = documents.filter((d) =>
    d.title.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="max-w-4xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader
        title="Documents"
        description="Upload and manage documents for your AI to reference"
        action={
            <Button icon={<Upload size={16} aria-hidden={true} />}>Upload</Button>
        }
      />

      <SearchInput value={search} onChange={setSearch} placeholder="Search documents..." />

      {filtered.length === 0 ? (
        <EmptyState
          icon={<FileText size={48} aria-hidden={true} />}
          title="No documents yet"
          description="Upload documents to give your AI companion more context"
          action={<Button icon={<Upload size={16} aria-hidden={true} />}>Upload document</Button>}
        />
      ) : (
        <div className="grid gap-3">
          {filtered.map((doc, i) => (
            <motion.div
              key={doc.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.05 }}
            >
              <Link href={`/documents/${doc.id}`}>
                <Card variant="interactive">
                  <CardContent>
                    <div className="flex items-center gap-4">
                      <div className="w-10 h-10 rounded-lg bg-primary-500/10 flex items-center justify-center">
                        <File size={20} className="text-primary-400" aria-hidden={true} />
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium text-neutral-0 truncate">{doc.title}</p>
                        <p className="text-xs text-surface-400">{doc.type} · {doc.size} · {formatRelativeTime(doc.uploaded_at)}</p>
                      </div>
                      <button aria-label="More options" className="text-surface-500 hover:text-neutral-0 transition-colors">
                        <MoreHorizontal size={18} aria-hidden={true} />
                      </button>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            </motion.div>
          ))}
        </div>
      )}
    </div>
  );
}
