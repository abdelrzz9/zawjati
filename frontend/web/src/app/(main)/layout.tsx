"use client";

import { useState, useEffect } from "react";
import { usePathname, useRouter } from "next/navigation";
import Link from "next/link";
import {
  MessageCircle,
  Brain,
  User,
  Settings,
  LogOut,
  Menu,
  X,
  LayoutDashboard,
  Bell,
  FileText,
  Mic,
  Sparkles,
} from "lucide-react";
import { cn } from "@/lib/utils";
import { useAuthStore } from "@/stores/auth-store";
import { useIsMobile } from "@/hooks/use-media-query";
import { Avatar } from "@/components/ui/avatar";
import { motion, AnimatePresence } from "framer-motion";

interface NavItem {
  label: string;
  href: string;
  icon: typeof MessageCircle;
}

const navItems: NavItem[] = [
  { label: "Chat", href: "/chat", icon: MessageCircle },
  { label: "Memory", href: "/memory", icon: Brain },
  { label: "Dashboard", href: "/dashboard", icon: LayoutDashboard },
  { label: "Personality", href: "/personality", icon: Sparkles },
  { label: "Documents", href: "/documents", icon: FileText },
  { label: "Voice", href: "/voice", icon: Mic },
  { label: "Notifications", href: "/notifications", icon: Bell },
  { label: "Profile", href: "/profile", icon: User },
  { label: "Settings", href: "/settings", icon: Settings },
];

export default function MainLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();
  const { user, logout, checkAuth } = useAuthStore();
  const isMobile = useIsMobile();
  const [sidebarOpen, setSidebarOpen] = useState(false);

  useEffect(() => {
    checkAuth();
  }, [checkAuth]);

  useEffect(() => {
    if (sidebarOpen && isMobile) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    return () => {
      document.body.style.overflow = "";
    };
  }, [sidebarOpen, isMobile]);

  const handleLogout = () => {
    logout();
    router.push("/login");
  };

  const closeSidebar = () => {
    if (isMobile) setSidebarOpen(false);
  };

  const sidebarContent = (
    <div className="flex flex-col h-full">
      <div className="p-4 border-b border-dark-border">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-lg bg-primary-500 flex items-center justify-center">
            <span className="text-white font-bold text-sm">Z</span>
          </div>
          <span className="font-semibold text-neutral-0">Zawjati</span>
        </div>
      </div>

      <nav className="flex-1 overflow-y-auto p-3 space-y-1">
        {navItems.map((item) => {
          const isActive = pathname.startsWith(item.href);
          return (
            <Link
              key={item.href}
              href={item.href}
              onClick={closeSidebar}
              className={cn(
                "flex items-center gap-3 px-3 py-2.5 rounded-md text-sm font-medium transition-colors duration-150",
                isActive
                  ? "bg-primary-500/10 text-primary-400"
                  : "text-surface-400 hover:text-neutral-0 hover:bg-dark-surface"
              )}
            >
              <item.icon size={18} />
              {item.label}
            </Link>
          );
        })}
      </nav>

      <div className="p-3 border-t border-dark-border">
        {user && (
          <Link
            href="/profile"
            onClick={closeSidebar}
            className="flex items-center gap-3 px-3 py-2.5 rounded-md text-sm text-surface-400 hover:text-neutral-0 hover:bg-dark-surface transition-colors"
          >
            <Avatar name={user.name} size="sm" />
            <div className="flex-1 min-w-0">
              <p className="text-neutral-0 font-medium truncate">{user.name}</p>
              <p className="text-surface-500 text-xs truncate">{user.email}</p>
            </div>
          </Link>
        )}
        <button
          onClick={() => {
            closeSidebar();
            handleLogout();
          }}
          className="flex items-center gap-3 px-3 py-2.5 rounded-md text-sm text-surface-400 hover:text-error hover:bg-error/5 transition-colors w-full mt-1"
        >
          <LogOut size={18} />
          Sign out
        </button>
      </div>
    </div>
  );

  return (
    <div className="h-screen flex overflow-hidden bg-dark-bg">
      {isMobile ? (
        <>
          <AnimatePresence>
            {sidebarOpen && (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="fixed inset-0 z-40 bg-black/60 backdrop-blur-sm"
                onClick={() => setSidebarOpen(false)}
              />
            )}
          </AnimatePresence>
          <AnimatePresence>
            {sidebarOpen && (
              <motion.aside
                initial={{ x: "-100%" }}
                animate={{ x: 0 }}
                exit={{ x: "-100%" }}
                transition={{ type: "spring", damping: 30, stiffness: 300 }}
                className="fixed inset-y-0 left-0 z-50 w-72 bg-dark-surface border-r border-dark-border shadow-2xl"
              >
                {sidebarContent}
              </motion.aside>
            )}
          </AnimatePresence>
        </>
      ) : (
        <aside className="w-64 flex-shrink-0 bg-dark-surface border-r border-dark-border overflow-y-auto">
          {sidebarContent}
        </aside>
      )}

      <div className="flex-1 flex flex-col min-w-0">
        {isMobile && (
          <header className="flex items-center gap-3 p-3 border-b border-dark-border bg-dark-surface">
            <button
              onClick={() => setSidebarOpen(true)}
              aria-label="Open menu"
              className="text-surface-400 hover:text-neutral-0"
            >
              <Menu size={20} aria-hidden={true} />
            </button>
            <div className="w-8 h-8 rounded-lg bg-primary-500 flex items-center justify-center">
              <span className="text-white font-bold text-sm">Z</span>
            </div>
            <span className="font-semibold text-neutral-0">Zawjati</span>
          </header>
        )}
        <main className="flex-1 overflow-y-auto">
          {children}
        </main>
      </div>
    </div>
  );
}
