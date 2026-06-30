import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { CodeBlock } from "./code-block";
import type { Components } from "react-markdown";

interface MarkdownViewProps {
  content: string;
}

export function MarkdownView({ content }: MarkdownViewProps) {
  const components: Components = {
    code: ({ className, children, ...props }) => {
      const match = /language-(\w+)/.exec(className || "");
      const code = String(children).replace(/\n$/, "");
      if (match) {
        return <CodeBlock code={code} language={match[1]} />;
      }
      return (
        <code
          className="px-1.5 py-0.5 rounded bg-surface-800 text-primary-300 text-sm font-mono"
          {...props}
        >
          {children}
        </code>
      );
    },
    pre: ({ children }) => <>{children}</>,
    a: ({ href, children }) => (
      <a
        href={href}
        target="_blank"
        rel="noopener noreferrer"
        className="text-primary-400 hover:underline"
      >
        {children}
      </a>
    ),
    ul: ({ children }) => (
      <ul className="list-disc list-inside space-y-1 my-2 text-neutral-0">{children}</ul>
    ),
    ol: ({ children }) => (
      <ol className="list-decimal list-inside space-y-1 my-2 text-neutral-0">{children}</ol>
    ),
    h1: ({ children }) => (
      <h1 className="text-xl font-bold text-neutral-0 my-4">{children}</h1>
    ),
    h2: ({ children }) => (
      <h2 className="text-lg font-bold text-neutral-0 my-3">{children}</h2>
    ),
    h3: ({ children }) => (
      <h3 className="text-base font-semibold text-neutral-0 my-2">{children}</h3>
    ),
    p: ({ children }) => (
      <p className="my-2 leading-relaxed text-neutral-0">{children}</p>
    ),
    blockquote: ({ children }) => (
      <blockquote className="border-l-4 border-primary-500 pl-4 my-2 text-surface-300 italic">
        {children}
      </blockquote>
    ),
    hr: () => <hr className="my-4 border-dark-border" />,
    table: ({ children }) => (
      <div className="overflow-x-auto my-3">
        <table className="min-w-full border-collapse border border-dark-border">
          {children}
        </table>
      </div>
    ),
    th: ({ children }) => (
      <th className="border border-dark-border px-3 py-2 bg-surface-900 text-sm font-semibold text-neutral-0">
        {children}
      </th>
    ),
    td: ({ children }) => (
      <td className="border border-dark-border px-3 py-2 text-sm text-neutral-0">
        {children}
      </td>
    ),
  };

  return (
    <ReactMarkdown
      remarkPlugins={[remarkGfm]}
      components={components}
    >
      {content}
    </ReactMarkdown>
  );
}
