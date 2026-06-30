"use client";

import { Button } from "@/components/ui/button";
import { AlertTriangle } from "lucide-react";

export default function AuthError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="min-h-screen flex items-center justify-center p-4 bg-dark-bg">
      <div className="text-center max-w-md">
        <AlertTriangle size={48} className="mx-auto text-error mb-4" aria-hidden={true} />
        <h1 className="text-xl font-bold text-neutral-0 mb-2">Authentication error</h1>
        <p className="text-surface-400 mb-6">
          Something went wrong. Please try signing in again.
        </p>
        <Button onClick={reset}>Try again</Button>
      </div>
    </div>
  );
}
