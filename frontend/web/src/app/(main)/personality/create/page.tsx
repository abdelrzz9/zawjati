"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { ArrowLeft, Sparkles, Plus, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { SectionHeader } from "@/components/ui/section-header";
import { Card, CardContent } from "@/components/ui/card";
import { showSuccess } from "@/components/ui/snackbar";

export default function CreatePersonalityPage() {
  const router = useRouter();
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [traits, setTraits] = useState<string[]>([]);
  const [traitInput, setTraitInput] = useState("");

  const addTrait = () => {
    const trimmed = traitInput.trim();
    if (trimmed && !traits.includes(trimmed)) {
      setTraits([...traits, trimmed]);
      setTraitInput("");
    }
  };

  const removeTrait = (trait: string) => {
    setTraits(traits.filter((t) => t !== trait));
  };

  const handleSubmit = () => {
    showSuccess("Personality created!");
    router.push("/personality");
  };

  return (
    <div className="max-w-2xl mx-auto p-4 md:p-6 space-y-6">
      <div className="flex items-center gap-3">
        <button onClick={() => router.back()} aria-label="Go back" className="text-surface-400 hover:text-neutral-0">
          <ArrowLeft size={20} aria-hidden={true} />
        </button>
        <SectionHeader title="Create Personality" description="Design a custom personality for your AI companion" />
      </div>

      <Card>
        <CardContent className="space-y-5">
          <Input
            label="Personality name"
            placeholder="e.g., Motivational Coach"
            value={name}
            onChange={(e) => setName(e.target.value)}
            icon={<Sparkles size={16} aria-hidden={true} />}
          />

          <div>
            <label className="block text-sm font-medium text-neutral-0 mb-1.5">Description</label>
            <textarea
              placeholder="Describe how this personality behaves..."
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={3}
              className="w-full rounded-md bg-dark-input border border-dark-border text-neutral-0 placeholder:text-surface-500 px-3 py-2 text-sm focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-500/30 resize-none"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-neutral-0 mb-1.5">Traits</label>
            <div className="flex gap-2 mb-2">
              <Input
                placeholder="Add a trait..."
                value={traitInput}
                onChange={(e) => setTraitInput(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && (e.preventDefault(), addTrait())}
              />
              <Button variant="secondary" onClick={addTrait} icon={<Plus size={16} aria-hidden={true} />}>
                Add
              </Button>
            </div>
            {traits.length > 0 && (
              <div className="flex flex-wrap gap-2 mt-2">
                {traits.map((trait) => (
                  <span
                    key={trait}
                    className="inline-flex items-center gap-1.5 px-3 py-1 rounded-pill bg-primary-500/10 text-primary-400 text-sm"
                  >
                    {trait}
                    <button onClick={() => removeTrait(trait)} aria-label={`Remove trait ${trait}`} className="hover:text-error">
                      <X size={14} aria-hidden={true} />
                    </button>
                  </span>
                ))}
              </div>
            )}
          </div>

          <div className="flex gap-2 pt-4">
            <Button onClick={handleSubmit} disabled={!name || !description}>
              Create personality
            </Button>
            <Button variant="secondary" onClick={() => router.back()}>
              Cancel
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
