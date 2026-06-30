import Link from "next/link";
import { Button } from "@/components/ui/button";
import { MessageCircle } from "lucide-react";

export default function ConversationNotFound() {
  return (
    <div className="h-full flex items-center justify-center p-4">
      <div className="text-center max-w-md">
        <MessageCircle size={48} className="mx-auto text-surface-400 mb-4" aria-hidden={true} />
        <h1 className="text-xl font-bold text-neutral-0 mb-2">Conversation not found</h1>
        <p className="text-surface-400 mb-6">
          This conversation doesn&apos;t exist or has been deleted.
        </p>
        <Link href="/chat">
          <Button>Back to conversations</Button>
        </Link>
      </div>
    </div>
  );
}
