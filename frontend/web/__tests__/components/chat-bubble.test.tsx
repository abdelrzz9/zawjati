import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";
import { ChatBubble } from "@/components/ui/chat-bubble";

describe("ChatBubble", () => {
  it("renders user message", () => {
    render(
      <ChatBubble role="user" content="Hello from user" timestamp="2024-01-01T00:00:00Z" />,
    );

    expect(screen.getByText("Hello from user")).toBeInTheDocument();
  });

  it("renders assistant message", () => {
    render(
      <ChatBubble role="assistant" content="Hello from assistant" />,
    );

    expect(screen.getByText("Hello from assistant")).toBeInTheDocument();
  });

  it("shows streaming indicator", () => {
    const { container } = render(
      <ChatBubble role="assistant" content="Partial" isStreaming />,
    );

    expect(container.querySelector(".animate-pulse")).toBeInTheDocument();
  });

  it("renders timestamp when provided", () => {
    const { container } = render(
      <ChatBubble
        role="user"
        content="Test"
        timestamp="2024-01-01T12:00:00Z"
      />,
    );

    const timeElement = container.querySelector(".text-xs.mt-1");
    expect(timeElement).toBeInTheDocument();
    expect(timeElement?.textContent).toMatch(/\d/);
  });
});
