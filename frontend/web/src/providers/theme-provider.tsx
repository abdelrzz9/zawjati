"use client";

import { useEffect, type ReactNode } from "react";
import { useSettingsStore } from "@/stores/settings-store";

const themes = {
  dark: {
    "--color-dark-bg": "#0b0b0f",
    "--color-dark-surface": "#16161c",
    "--color-dark-card": "#16161c",
    "--color-dark-border": "#262630",
    "--color-dark-input": "#111116",
    "--color-surface-50": "#f8f8ff",
    "--color-surface-100": "#f0f0f8",
    "--color-surface-200": "#e0e0e8",
    "--color-surface-300": "#c4c4ce",
    "--color-surface-400": "#9a9aa6",
    "--color-surface-500": "#6b6b78",
    "--color-surface-600": "#4a4a57",
    "--color-surface-700": "#33333f",
    "--color-surface-800": "#262630",
    "--color-surface-900": "#1e1e26",
    "--color-surface-950": "#111116",
    "--color-primary-400": "#8b78ff",
    "--color-primary-500": "#6e56f8",
    "--color-primary-600": "#5b44e0",
    "--color-neutral-0": "#f4f4f6",
    "--color-neutral-100": "#c4c4ce",
    "--color-neutral-200": "#9a9aa6",
    "--color-neutral-300": "#6b6b78",
    "--color-neutral-400": "#4a4a57",
    "--color-error": "#f87171",
    "--color-success": "#34d399",
    "--text-color": "#f4f4f6",
    "--bg-color": "#0b0b0f",
  },
  light: {
    "--color-dark-bg": "#ffffff",
    "--color-dark-surface": "#f8f8ff",
    "--color-dark-card": "#ffffff",
    "--color-dark-border": "#e0e0e8",
    "--color-dark-input": "#f0f0f8",
    "--color-surface-50": "#ffffff",
    "--color-surface-100": "#fafafa",
    "--color-surface-200": "#f5f5f5",
    "--color-surface-300": "#e5e5e5",
    "--color-surface-400": "#a3a3a3",
    "--color-surface-500": "#737373",
    "--color-surface-600": "#525252",
    "--color-surface-700": "#404040",
    "--color-surface-800": "#262626",
    "--color-surface-900": "#171717",
    "--color-surface-950": "#0a0a0a",
    "--color-primary-400": "#7c5cfc",
    "--color-primary-500": "#6e56f8",
    "--color-primary-600": "#5b44e0",
    "--color-neutral-0": "#171717",
    "--color-neutral-100": "#262626",
    "--color-neutral-200": "#404040",
    "--color-neutral-300": "#525252",
    "--color-neutral-400": "#737373",
    "--color-error": "#dc2626",
    "--color-success": "#059669",
    "--text-color": "#171717",
    "--bg-color": "#ffffff",
  },
  amoled: {
    "--color-dark-bg": "#000000",
    "--color-dark-surface": "#0a0a0a",
    "--color-dark-card": "#0a0a0a",
    "--color-dark-border": "#1a1a1a",
    "--color-dark-input": "#050505",
    "--color-surface-50": "#f8f8ff",
    "--color-surface-100": "#f0f0f8",
    "--color-surface-200": "#e0e0e8",
    "--color-surface-300": "#c4c4ce",
    "--color-surface-400": "#8a8a8a",
    "--color-surface-500": "#5c5c5c",
    "--color-surface-600": "#3d3d3d",
    "--color-surface-700": "#2a2a2a",
    "--color-surface-800": "#1a1a1a",
    "--color-surface-900": "#111111",
    "--color-surface-950": "#050505",
    "--color-primary-400": "#8b78ff",
    "--color-primary-500": "#6e56f8",
    "--color-primary-600": "#5b44e0",
    "--color-neutral-0": "#f0f0f0",
    "--color-neutral-100": "#b8b8b8",
    "--color-neutral-200": "#8a8a8a",
    "--color-neutral-300": "#5c5c5c",
    "--color-neutral-400": "#3d3d3d",
    "--color-error": "#f87171",
    "--color-success": "#34d399",
    "--text-color": "#f0f0f0",
    "--bg-color": "#000000",
  },
};

export function ThemeProvider({ children }: { children: ReactNode }) {
  const { theme } = useSettingsStore();

  useEffect(() => {
    const root = document.documentElement;
    const vars = themes[theme as keyof typeof themes] || themes.dark;

    Object.entries(vars).forEach(([key, value]) => {
      root.style.setProperty(key, value);
    });

    document.body.style.backgroundColor = vars["--bg-color"];
    document.body.style.color = vars["--text-color"];
  }, [theme]);

  return <>{children}</>;
}
