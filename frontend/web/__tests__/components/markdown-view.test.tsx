import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";
import { MarkdownView } from "@/components/ui/markdown-view";

describe("MarkdownView", () => {
  it("renders plain text", () => {
    render(<MarkdownView content="Hello World" />);
    expect(screen.getByText("Hello World")).toBeInTheDocument();
  });

  it("renders bold text", () => {
    render(<MarkdownView content="**bold** text" />);
    expect(screen.getByText("bold")).toBeInTheDocument();
  });

  it("renders code blocks", () => {
    const { container } = render(
      <MarkdownView content={"```\nconst x = 1;\n```"} />,
    );
    expect(container.querySelector("code")).toBeInTheDocument();
  });

  it("renders links", () => {
    render(<MarkdownView content="[click](https://example.com)" />);
    expect(screen.getByRole("link")).toHaveAttribute(
      "href",
      "https://example.com",
    );
  });

  it("renders lists", () => {
    const { container } = render(<MarkdownView content="- item 1\n- item 2" />);
    const list = container.querySelector("ul");
    expect(list).toBeInTheDocument();
    expect(list?.textContent).toMatch(/item/);
  });

  it("renders headings", () => {
    render(<MarkdownView content="# Heading 1" />);
    expect(screen.getByRole("heading", { level: 1 })).toBeInTheDocument();
  });
});
