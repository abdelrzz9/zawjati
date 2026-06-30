"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import {
  User,
  Mail,
  Globe,
  Heart,
  Edit2,
  Save,
  X,
  MessageCircle,
  Brain,
  Calendar,
  Award,
} from "lucide-react";
import { useAuthStore } from "@/stores/auth-store";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Avatar } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { SectionHeader } from "@/components/ui/section-header";
import { showSuccess, showError } from "@/components/ui/snackbar";
import type { DashboardStats } from "@/types";

const mockStats: DashboardStats = {
  total_conversations: 47,
  total_messages: 892,
  total_memories: 156,
  active_days: 23,
  words_learned: 12450,
  conversations_this_week: 12,
};

export default function ProfilePage() {
  const { user } = useAuthStore();
  const [editing, setEditing] = useState(false);
  const [name, setName] = useState(user?.name || "");

  const handleSave = () => {
    if (!name.trim()) {
      showError("Name cannot be empty");
      return;
    }
    showSuccess("Profile updated");
    setEditing(false);
  };

  if (!user) return null;

  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader title="Profile" description="Manage your personal information" />

      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
      >
        <Card>
          <CardHeader>
            <CardTitle>Personal Information</CardTitle>
            {!editing ? (
              <Button
                variant="ghost"
                size="sm"
                icon={<Edit2 size={14} />}
                onClick={() => setEditing(true)}
              >
                Edit
              </Button>
            ) : (
              <div className="flex gap-1">
                <Button
                  variant="ghost"
                  size="sm"
                  aria-label="Save changes"
                  icon={<Save size={14} aria-hidden={true} />}
                  onClick={handleSave}
                />
                <Button
                  variant="ghost"
                  size="sm"
                  aria-label="Cancel"
                  icon={<X size={14} aria-hidden={true} />}
                  onClick={() => {
                    setEditing(false);
                    setName(user.name);
                  }}
                />
              </div>
            )}
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center gap-4 mb-6">
              <Avatar name={user.name} size="xl" src={user.avatar_url} />
              <div>
                <h2 className="text-xl font-semibold text-neutral-0">{user.name}</h2>
                <p className="text-sm text-surface-400">{user.email}</p>
              </div>
            </div>

            {editing ? (
              <div className="space-y-4">
                <Input
                  label="Full name"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  icon={<User size={16} />}
                />
                <Input
                  label="Email"
                  value={user.email}
                  disabled
                  icon={<Mail size={16} />}
                />
              </div>
            ) : (
              <div className="space-y-3">
                <div className="flex items-center gap-3 text-sm">
                  <Mail size={16} className="text-surface-400" aria-hidden={true} />
                  <span className="text-neutral-0">{user.email}</span>
                </div>
                <div className="flex items-center gap-3 text-sm">
                  <Globe size={16} className="text-surface-400" aria-hidden={true} />
                  <span className="text-neutral-0">{user.language.toUpperCase()}</span>
                </div>
                <div className="flex items-center gap-3 text-sm">
                  <Heart size={16} className="text-surface-400" aria-hidden={true} />
                  <span className="text-neutral-0">{user.personality}</span>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </motion.div>

      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
      >
        <Card>
          <CardHeader>
            <CardTitle>Statistics</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
              <div className="text-center p-3 rounded-lg bg-dark-surface">
                <MessageCircle size={20} className="mx-auto mb-1 text-primary-400" aria-hidden={true} />
                <p className="text-2xl font-bold text-neutral-0">{mockStats.total_conversations}</p>
                <p className="text-xs text-surface-500">Conversations</p>
              </div>
              <div className="text-center p-3 rounded-lg bg-dark-surface">
                <MessageCircle size={20} className="mx-auto mb-1 text-blue-400" aria-hidden={true} />
                <p className="text-2xl font-bold text-neutral-0">{mockStats.total_messages}</p>
                <p className="text-xs text-surface-500">Messages</p>
              </div>
              <div className="text-center p-3 rounded-lg bg-dark-surface">
                <Brain size={20} className="mx-auto mb-1 text-emerald-400" aria-hidden={true} />
                <p className="text-2xl font-bold text-neutral-0">{mockStats.total_memories}</p>
                <p className="text-xs text-surface-500">Memories</p>
              </div>
              <div className="text-center p-3 rounded-lg bg-dark-surface">
                <Calendar size={20} className="mx-auto mb-1 text-amber-400" aria-hidden={true} />
                <p className="text-2xl font-bold text-neutral-0">{mockStats.active_days}</p>
                <p className="text-xs text-surface-500">Active days</p>
              </div>
              <div className="text-center p-3 rounded-lg bg-dark-surface">
                <Award size={20} className="mx-auto mb-1 text-purple-400" aria-hidden={true} />
                <p className="text-2xl font-bold text-neutral-0">{(mockStats.words_learned / 1000).toFixed(1)}K</p>
                <p className="text-xs text-surface-500">Words learned</p>
              </div>
              <div className="text-center p-3 rounded-lg bg-dark-surface">
                <MessageCircle size={20} className="mx-auto mb-1 text-rose-400" aria-hidden={true} />
                <p className="text-2xl font-bold text-neutral-0">{mockStats.conversations_this_week}</p>
                <p className="text-xs text-surface-500">This week</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
}
