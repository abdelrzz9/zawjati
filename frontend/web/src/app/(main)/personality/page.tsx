"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import { Sparkles, Plus, Heart, Zap, Brain, Star } from "lucide-react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { SectionHeader } from "@/components/ui/section-header";
import { EmptyState } from "@/components/ui/empty-state";
import { cn } from "@/lib/utils";
import type { Personality } from "@/types";

const mockPersonalities: Personality[] = [
  { id: "1", name: "Empathetic", description: "A caring and understanding companion who listens deeply", traits: ["Compassionate", "Patient", "Warm"], is_active: true, created_at: "2024-01-15" },
  { id: "2", name: "Creative", description: "An imaginative partner who thinks outside the box", traits: ["Innovative", "Playful", "Artistic"], is_active: false, created_at: "2024-02-20" },
  { id: "3", name: "Analytical", description: "A logical thinker who helps solve complex problems", traits: ["Rational", "Precise", "Objective"], is_active: false, created_at: "2024-03-10" },
];

const iconMap = [Heart, Zap, Brain];

export default function PersonalityPage() {
  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader
        title="Personality"
        description="Choose how your AI companion interacts with you"
        action={
          <Link href="/personality/create">
            <Button size="sm" icon={<Plus size={14} aria-hidden={true} />}>Create</Button>
          </Link>
        }
      />

      {mockPersonalities.length === 0 ? (
        <EmptyState
          icon={<Sparkles size={48} aria-hidden={true} />}
          title="No personalities yet"
          description="Create a custom personality for your AI companion"
          action={<Button icon={<Plus size={16} aria-hidden={true} />}>Create personality</Button>}
        />
      ) : (
        <div className="space-y-3">
          {mockPersonalities.map((personality, i) => {
            const Icon = iconMap[i % iconMap.length];
            return (
              <motion.div
                key={personality.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.05 }}
              >
                <Card className={cn(
                  "relative overflow-hidden",
                  personality.is_active && "border-primary-500 ring-1 ring-primary-500/30"
                )}>
                  <CardHeader>
                    <div className="flex items-center gap-3">
                      <div className={cn(
                        "w-10 h-10 rounded-lg flex items-center justify-center",
                        personality.is_active ? "bg-primary-500/20 text-primary-400" : "bg-dark-surface text-surface-400"
                      )}>
                        <Icon size={20} aria-hidden={true} />
                      </div>
                      <div className="flex-1">
                        <CardTitle>{personality.name}</CardTitle>
                        <p className="text-xs text-surface-400">{personality.description}</p>
                      </div>
                      {personality.is_active && (
                        <Badge variant="primary" size="sm">Active</Badge>
                      )}
                    </div>
                  </CardHeader>
                  <CardContent>
                    <div className="flex items-center gap-2">
                      {personality.traits.map((trait) => (
                        <span key={trait} className="text-xs text-surface-400 bg-dark-surface px-2 py-1 rounded-pill">
                          {trait}
                        </span>
                      ))}
                    </div>
                  </CardContent>
                </Card>
              </motion.div>
            );
          })}
        </div>
      )}
    </div>
  );
}
