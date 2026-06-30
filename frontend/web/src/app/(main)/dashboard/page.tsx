"use client";

import { motion } from "framer-motion";
import { MessageCircle, Brain, Calendar, TrendingUp, Activity } from "lucide-react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { SectionHeader } from "@/components/ui/section-header";
import { Badge } from "@/components/ui/badge";
import { formatRelativeTime } from "@/lib/utils";

const stats = [
  { label: "Total conversations", value: "47", icon: MessageCircle, color: "text-primary-400", bg: "bg-primary-500/10", change: "+12%" },
  { label: "Messages sent", value: "892", icon: Activity, color: "text-blue-400", bg: "bg-blue-500/10", change: "+8%" },
  { label: "Memories stored", value: "156", icon: Brain, color: "text-emerald-400", bg: "bg-emerald-500/10", change: "+23%" },
  { label: "Active days", value: "23", icon: Calendar, color: "text-amber-400", bg: "bg-amber-500/10", change: "+5%" },
];

const recentActivity = [
  { id: "1", action: "New conversation", detail: "Asked about programming", time: new Date(Date.now() - 3600000).toISOString() },
  { id: "2", action: "Memory created", detail: "Learned your favorite books", time: new Date(Date.now() - 7200000).toISOString() },
  { id: "3", action: "Document uploaded", detail: "Project requirements.pdf", time: new Date(Date.now() - 14400000).toISOString() },
  { id: "4", action: "Personality updated", detail: "Changed to 'Creative'", time: new Date(Date.now() - 86400000).toISOString() },
];

export default function DashboardPage() {
  return (
    <div className="max-w-4xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader
        title="Dashboard"
        description="Your activity overview"
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        {stats.map((stat, i) => {
          const Icon = stat.icon;
          return (
            <motion.div
              key={stat.label}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.05 }}
            >
              <Card>
                <CardContent>
                  <div className="flex items-start justify-between mb-3">
                    <div className={`w-9 h-9 rounded-lg ${stat.bg} flex items-center justify-center`}>
                      <Icon size={18} className={stat.color} aria-hidden={true} />
                    </div>
                    <Badge variant="success" size="sm">{stat.change}</Badge>
                  </div>
                  <p className="text-2xl font-bold text-neutral-0">{stat.value}</p>
                  <p className="text-xs text-surface-400 mt-1">{stat.label}</p>
                </CardContent>
              </Card>
            </motion.div>
          );
        })}
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Card>
          <CardHeader>
            <CardTitle>Recent Activity</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {recentActivity.map((activity) => (
                <div key={activity.id} className="flex items-start gap-3 pb-3 border-b border-dark-border last:border-0 last:pb-0">
                  <div className="w-2 h-2 rounded-full bg-primary-400 mt-1.5 flex-shrink-0" />
                  <div className="flex-1 min-w-0">
                    <p className="text-sm text-neutral-0">{activity.action}</p>
                    <p className="text-xs text-surface-400">{activity.detail}</p>
                  </div>
                  <span className="text-xs text-surface-500 flex-shrink-0">{formatRelativeTime(activity.time)}</span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Weekly Activity</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex items-end justify-between h-32 gap-2">
              {["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((day, i) => {
                const height = 20 + Math.random() * 80;
                return (
                  <div key={day} className="flex-1 flex flex-col items-center gap-1">
                    <div
                      className="w-full rounded-md bg-primary-500/30 hover:bg-primary-500/50 transition-colors"
                      style={{ height: `${height}%` }}
                    />
                    <span className="text-xs text-surface-500">{day}</span>
                  </div>
                );
              })}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
