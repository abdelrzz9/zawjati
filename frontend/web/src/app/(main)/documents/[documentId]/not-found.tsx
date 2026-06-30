import Link from "next/link";
import { Button } from "@/components/ui/button";
import { FileText } from "lucide-react";

export default function DocumentNotFound() {
  return (
    <div className="max-w-3xl mx-auto p-4 md:p-6">
      <div className="text-center max-w-md mx-auto py-16">
        <FileText size={48} className="mx-auto text-surface-400 mb-4" aria-hidden={true} />
        <h1 className="text-xl font-bold text-neutral-0 mb-2">Document not found</h1>
        <p className="text-surface-400 mb-6">
          This document doesn&apos;t exist or has been deleted.
        </p>
        <Link href="/documents">
          <Button>Back to documents</Button>
        </Link>
      </div>
    </div>
  );
}
