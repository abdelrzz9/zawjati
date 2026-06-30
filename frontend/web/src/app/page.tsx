"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuthStore } from "@/stores/auth-store";
import { LoadingScreen } from "@/components/ui/loading-screen";

export default function Home() {
  const router = useRouter();
  const { isAuthenticated, isLoading, checkAuth } = useAuthStore();

  useEffect(() => {
    checkAuth();
  }, [checkAuth]);

  useEffect(() => {
    if (isLoading) return;
    if (isAuthenticated) {
      router.replace("/chat");
    } else {
      const seenOnboarding = localStorage.getItem("seen_onboarding");
      if (seenOnboarding) {
        router.replace("/login");
      } else {
        router.replace("/onboarding");
      }
    }
  }, [isAuthenticated, isLoading, router]);

  return <LoadingScreen />;
}
