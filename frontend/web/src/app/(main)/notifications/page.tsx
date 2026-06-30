"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Bell, CheckCheck, Info, AlertTriangle, CheckCircle, XCircle } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { SectionHeader } from "@/components/ui/section-header";
import { EmptyState } from "@/components/ui/empty-state";
import { cn, formatRelativeTime } from "@/lib/utils";
import type { Notification } from "@/types";

const mockNotifications: Notification[] = [
  { id: "1", title: "New memory created", message: "I've learned something new about you!", type: "info", read: false, created_at: new Date(Date.now() - 3600000).toISOString() },
  { id: "2", title: "Weekly report ready", message: "Your weekly conversation summary is available.", type: "success", read: false, created_at: new Date(Date.now() - 86400000).toISOString() },
  { id: "3", title: "Storage limit warning", message: "You're approaching your storage limit.", type: "warning", read: true, created_at: new Date(Date.now() - 172800000).toISOString() },
  { id: "4", title: "Conversation deleted", message: "A conversation was automatically deleted.", type: "error", read: true, created_at: new Date(Date.now() - 259200000).toISOString() },
];

const typeIcons = {
  info: Info,
  warning: AlertTriangle,
  success: CheckCircle,
  error: XCircle,
};

const typeColors = {
  info: "text-info bg-info/10",
  warning: "text-warning bg-warning/10",
  success: "text-success bg-success/10",
  error: "text-error bg-error/10",
};

export default function NotificationsPage() {
  const [notifications] = useState(mockNotifications);
  const unread = notifications.filter((n) => !n.read).length;

  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader
        title="Notifications"
        description={unread > 0 ? `You have ${unread} unread notifications` : "No unread notifications"}
        action={
          unread > 0 && (
            <Button variant="ghost" size="sm" icon={<CheckCheck size={14} aria-hidden={true} />}>
              Mark all read
            </Button>
          )
        }
      />

      {notifications.length === 0 ? (
        <EmptyState
          icon={<Bell size={48} aria-hidden={true} />}
          title="No notifications"
          description="You're all caught up"
        />
      ) : (
        <div className="space-y-2">
          {notifications.map((notif, i) => {
            const Icon = typeIcons[notif.type];
            return (
              <motion.div
                key={notif.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.05 }}
              >
                <Card className={cn(!notif.read && "border-primary-500/30")}>
                  <CardContent>
                    <div className="flex items-start gap-3">
                      <div className={`w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 ${typeColors[notif.type]}`}>
                        <Icon size={18} aria-hidden={true} />
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-2">
                          <p className="text-sm font-medium text-neutral-0">{notif.title}</p>
                          {!notif.read && <span className="w-2 h-2 rounded-full bg-primary-400" />}
                        </div>
                        <p className="text-xs text-surface-400 mt-0.5">{notif.message}</p>
                        <p className="text-xs text-surface-500 mt-1">{formatRelativeTime(notif.created_at)}</p>
                      </div>
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
