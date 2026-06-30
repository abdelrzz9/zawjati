"use client";

import { useEffect } from "react";
import { Button } from "@/components/ui/button";
import { AlertTriangle } from "lucide-react";

export default function MainError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error(error);
  }, [error]);

  return (
    <div className="flex items-center justify-center p-8 h-full">
      <div className="text-center max-w-md">
        <AlertTriangle size={48} className="mx-auto text-error mb-4" aria-hidden={true} />
        <h2 className="text-lg font-semibold text-neutral-0 mb-2">Something went wrong</h2>
        <p className="text-surface-400 mb-4">
          An unexpected error occurred in this section.
        </p>
        <Button onClick={reset} size="sm">Try again</Button>
      </div>
    </div>
  );
}
