"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Mic, Square, Volume2, Play, Pause } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { SectionHeader } from "@/components/ui/section-header";
import { cn } from "@/lib/utils";

interface VoiceSession {
  id: string;
  title: string;
  duration: string;
  date: string;
}

const sessions: VoiceSession[] = [
  { id: "1", title: "Morning chat", duration: "5:23", date: "Today" },
  { id: "2", title: "Brainstorming ideas", duration: "12:10", date: "Yesterday" },
  { id: "3", title: "Reflection", duration: "8:45", date: "2 days ago" },
];

export default function VoicePage() {
  const [isRecording, setIsRecording] = useState(false);
  const [playingId, setPlayingId] = useState<string | null>(null);

  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader title="Voice" description="Voice conversations with your AI companion" />

      <div className="flex flex-col items-center py-8">
        <motion.button
          whileTap={{ scale: 0.95 }}
          aria-label={isRecording ? "Stop recording" : "Start recording"}
          onClick={() => setIsRecording(!isRecording)}
          className={cn(
            "w-24 h-24 rounded-full flex items-center justify-center transition-all",
            isRecording
              ? "bg-error text-white shadow-lg shadow-error/30 animate-pulse"
              : "bg-primary-500 text-white shadow-lg shadow-primary-500/30 hover:bg-primary-600"
          )}
        >
          {isRecording ? <Square size={28} aria-hidden={true} /> : <Mic size={28} aria-hidden={true} />}
        </motion.button>
        <p className="text-sm text-surface-400 mt-4">
          {isRecording ? "Recording... tap to stop" : "Tap to start recording"}
        </p>
        {isRecording && (
          <div className="flex items-center gap-1 mt-4">
            {[...Array(12)].map((_, i) => (
              <motion.div
                key={i}
                className="w-1 bg-primary-400 rounded-full"
                animate={{ height: [4, 20 + Math.random() * 20, 4] }}
                transition={{ duration: 0.5, repeat: Infinity, delay: i * 0.1 }}
              />
            ))}
          </div>
        )}
      </div>

      <div className="space-y-2">
        <h3 className="text-sm font-medium text-neutral-0 mb-3">Recent recordings</h3>
        {sessions.map((session) => (
          <Card key={session.id} variant="interactive">
            <CardContent>
              <div className="flex items-center gap-4">
                <button
                  onClick={() => setPlayingId(playingId === session.id ? null : session.id)}
                  aria-label={playingId === session.id ? "Pause" : "Play"}
                  className="w-9 h-9 rounded-full bg-primary-500/20 text-primary-400 flex items-center justify-center hover:bg-primary-500/30 transition-colors"
                >
                  {playingId === session.id ? <Pause size={16} aria-hidden={true} /> : <Play size={16} aria-hidden={true} />}
                </button>
                <div className="flex-1">
                  <p className="text-sm font-medium text-neutral-0">{session.title}</p>
                  <p className="text-xs text-surface-400">{session.date} · {session.duration}</p>
                </div>
                <Volume2 size={18} className="text-surface-500" aria-hidden={true} />
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
