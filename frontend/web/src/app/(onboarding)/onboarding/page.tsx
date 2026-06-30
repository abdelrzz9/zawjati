"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import { ChevronRight, MessageCircle, Brain, Shield } from "lucide-react";
import { Button } from "@/components/ui/button";

interface Slide {
  title: string;
  description: string;
  icon: typeof MessageCircle;
  color: string;
}

const slides: Slide[] = [
  {
    title: "Your AI Companion",
    description: "Meet Zawjati, an intelligent AI companion that learns from every conversation. Chat naturally and build a meaningful connection.",
    icon: MessageCircle,
    color: "from-primary-500 to-primary-700",
  },
  {
    title: "Remembers Everything",
    description: "Zawjati remembers your preferences, memories, and past conversations. Every interaction makes your companion more personalized.",
    icon: Brain,
    color: "from-blue-500 to-blue-700",
  },
  {
    title: "Privacy First",
    description: "Your conversations are encrypted and private. You have full control over your data, with the ability to delete memories anytime.",
    icon: Shield,
    color: "from-emerald-500 to-emerald-700",
  },
];

export default function OnboardingPage() {
  const router = useRouter();
  const [currentSlide, setCurrentSlide] = useState(0);
  const slide = slides[currentSlide];
  const isLast = currentSlide === slides.length - 1;

  const handleNext = () => {
    if (isLast) {
      localStorage.setItem("seen_onboarding", "true");
      router.replace("/login");
    } else {
      setCurrentSlide((prev) => prev + 1);
    }
  };

  const handleSkip = () => {
    localStorage.setItem("seen_onboarding", "true");
    router.replace("/login");
  };

  return (
    <div className="min-h-screen flex flex-col bg-dark-bg">
      <div className="flex justify-end p-4">
        <button
          onClick={handleSkip}
          className="text-sm text-surface-400 hover:text-neutral-0 transition-colors"
        >
          Skip
        </button>
      </div>

      <div className="flex-1 flex items-center justify-center px-6">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentSlide}
            initial={{ opacity: 0, x: 50 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -50 }}
            transition={{ duration: 0.3, ease: "easeInOut" }}
            className="flex flex-col items-center text-center max-w-sm"
          >
            <div
              className={`w-32 h-32 rounded-2xl bg-gradient-to-br ${slide.color} flex items-center justify-center mb-8 shadow-lg shadow-primary-500/20`}
            >
              <slide.icon size={48} className="text-white" aria-hidden={true} />
            </div>

            <h1 className="text-2xl font-bold text-neutral-0 mb-3">
              {slide.title}
            </h1>
            <p className="text-surface-400 leading-relaxed">
              {slide.description}
            </p>
          </motion.div>
        </AnimatePresence>
      </div>

      <div className="p-6 space-y-6">
        <div className="flex justify-center gap-2">
          {slides.map((_, i) => (
            <button
              key={i}
              onClick={() => setCurrentSlide(i)}
              className={`h-2 rounded-full transition-all duration-300 ${
                i === currentSlide
                  ? "w-8 bg-primary-500"
                  : "w-2 bg-surface-700 hover:bg-surface-600"
              }`}
            />
          ))}
        </div>

        <Button onClick={handleNext} className="w-full" size="lg">
          {isLast ? "Get Started" : "Next"}
          <ChevronRight size={18} aria-hidden={true} />
        </Button>
      </div>
    </div>
  );
}
