"use client";

import { useState } from "react";
import {
  Brain,
  Star,
  Clock,
  Filter,
  Trash2,
} from "lucide-react";
import { motion } from "framer-motion";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { SearchInput } from "@/components/ui/search-input";
import { SectionHeader } from "@/components/ui/section-header";
import { EmptyState } from "@/components/ui/empty-state";
import { formatRelativeTime, cn } from "@/lib/utils";
import type { MemoryItem } from "@/types";

const categories = ["All", "Personal", "Preferences", "Facts", "Goals", "Memories"];

const mockMemories: MemoryItem[] = [
  {
    id: "1",
    content: "User enjoys reading science fiction novels, especially works by Isaac Asimov",
    category: "Preferences",
    importance: 3,
    created_at: new Date(Date.now() - 86400000).toISOString(),
    updated_at: new Date(Date.now() - 86400000).toISOString(),
    tags: ["books", "scifi", "reading"],
  },
  {
    id: "2",
    content: "User is learning Spanish and practices daily with language apps",
    category: "Goals",
    importance: 4,
    created_at: new Date(Date.now() - 172800000).toISOString(),
    updated_at: new Date(Date.now() - 172800000).toISOString(),
    tags: ["learning", "spanish", "languages"],
  },
  {
    id: "3",
    content: "User has a cat named Luna who is 3 years old",
    category: "Personal",
    importance: 2,
    created_at: new Date(Date.now() - 259200000).toISOString(),
    updated_at: new Date(Date.now() - 259200000).toISOString(),
    tags: ["pets", "cats"],
  },
];

export default function MemoryPage() {
  const [search, setSearch] = useState("");
  const [activeCategory, setActiveCategory] = useState("All");
  const [sortBy, setSortBy] = useState("recent");

  const filteredMemories = mockMemories.filter((m) => {
    const matchesSearch = m.content.toLowerCase().includes(search.toLowerCase()) ||
      m.tags.some((t) => t.includes(search.toLowerCase()));
    const matchesCategory = activeCategory === "All" || m.category === activeCategory;
    return matchesSearch && matchesCategory;
  });

  return (
    <div className="max-w-4xl mx-auto p-4 md:p-6 space-y-6">
      <SectionHeader
        title="Memory"
        description="Everything your AI companion remembers about you"
        action={
          <div className="flex items-center gap-2">
            <button aria-label="Filter" className="text-surface-400 hover:text-neutral-0 transition-colors">
              <Filter size={18} aria-hidden={true} />
            </button>
          </div>
        }
      />

      <div className="flex flex-col sm:flex-row gap-3">
        <SearchInput
          value={search}
          onChange={setSearch}
          placeholder="Search memories..."
          className="flex-1"
        />
        <select
          value={sortBy}
          onChange={(e) => setSortBy(e.target.value)}
          className="h-10 px-3 rounded-md bg-dark-input border border-dark-border text-neutral-0 text-sm focus:outline-none focus:border-primary-500"
        >
          <option value="recent">Most recent</option>
          <option value="important">Most important</option>
          <option value="oldest">Oldest first</option>
        </select>
      </div>

      <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
        {categories.map((cat) => (
          <button
            key={cat}
            onClick={() => setActiveCategory(cat)}
            className={cn(
              "px-3 py-1.5 rounded-pill text-sm font-medium whitespace-nowrap transition-colors",
              activeCategory === cat
                ? "bg-primary-500 text-white"
                : "bg-dark-surface text-surface-400 border border-dark-border hover:text-neutral-0"
            )}
          >
            {cat}
          </button>
        ))}
      </div>

      {filteredMemories.length === 0 ? (
        <EmptyState
          icon={                  <Brain size={48} aria-hidden={true} />}
          title="No memories found"
          description="Your AI companion will build memories from your conversations"
        />
      ) : (
        <div className="grid gap-3">
          {filteredMemories.map((memory, i) => (
            <motion.div
              key={memory.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.05 }}
            >
              <Card variant="interactive">
                <CardHeader>
                  <div className="flex items-center gap-2">
                    <Badge variant="primary" size="sm">{memory.category}</Badge>
                    <div className="flex items-center gap-0.5">
                      {[...Array(5)].map((_, j) => (
                        <Star
                          key={j}
                          size={12}
                          aria-hidden={true}
                          className={j < memory.importance ? "text-warning fill-warning" : "text-surface-700"}
                        />
                      ))}
                    </div>
                  </div>
                  <button aria-label="Delete memory" className="text-surface-500 hover:text-error transition-colors">
                    <Trash2 size={14} aria-hidden={true} />
                  </button>
                </CardHeader>
                <CardContent>
                  <p className="text-neutral-0 text-sm mb-3">{memory.content}</p>
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2 text-xs text-surface-500">
                      <Clock size={12} aria-hidden={true} />
                      {formatRelativeTime(memory.updated_at)}
                    </div>
                    <div className="flex items-center gap-1.5">
                      {memory.tags.map((tag) => (
                        <span
                          key={tag}
                          className="text-xs text-surface-400 bg-surface-800 px-1.5 py-0.5 rounded"
                        >
                          #{tag}
                        </span>
                      ))}
                    </div>
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>
      )}
    </div>
  );
}
