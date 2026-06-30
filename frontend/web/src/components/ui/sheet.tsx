"use client";

import { useEffect, type ReactNode } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X } from "lucide-react";
import { cn } from "@/lib/utils";

interface SheetProps {
  open: boolean;
  onClose: () => void;
  children: ReactNode;
  title?: string;
  side?: "left" | "right";
  className?: string;
}

export function Sheet({
  open,
  onClose,
  children,
  title,
  side = "right",
  className,
}: SheetProps) {
  useEffect(() => {
    if (open) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    return () => {
      document.body.style.overflow = "";
    };
  }, [open]);

  const slideFrom = side === "right" ? { x: "100%" } : { x: "-100%" };
  const slideTo = { x: 0 };

  return (
    <AnimatePresence>
      {open && (
        <div className="fixed inset-0 z-50">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-black/60 backdrop-blur-sm"
            onClick={onClose}
          />
          <motion.div
            initial={slideFrom}
            animate={slideTo}
            exit={slideFrom}
            transition={{ type: "spring", damping: 30, stiffness: 300 }}
            className={cn(
              "absolute top-0 bottom-0 w-full max-w-sm bg-dark-surface border-dark-border shadow-2xl flex flex-col",
              side === "right" ? "right-0 border-l" : "left-0 border-r",
              className
            )}
          >
            <div className="flex items-center justify-between p-4 border-b border-dark-border">
              {title && (
                <h2 className="text-lg font-semibold text-neutral-0">{title}</h2>
              )}
              <button
                onClick={onClose}
                aria-label="Close"
                className="text-surface-400 hover:text-neutral-0 transition-colors ml-auto"
              >
                <X size={20} aria-hidden={true} />
              </button>
            </div>
            <div className="flex-1 overflow-y-auto p-4">{children}</div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
