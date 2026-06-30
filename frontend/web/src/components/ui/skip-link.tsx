"use client";

import { t } from "@/lib/i18n";

interface SkipLinkProps {
  locale?: string;
}

export function SkipLink({ locale = "en" }: SkipLinkProps) {
  return (
    <a
      href="#main-content"
      className="sr-only focus:not-sr-only focus:fixed focus:top-4 focus:left-4 focus:z-50 focus:px-4 focus:py-2 focus:bg-primary-500 focus:text-white focus:rounded-md focus:outline-none"
    >
      {t("accessibility.skipToContent", locale)}
    </a>
  );
}
