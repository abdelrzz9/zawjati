import { cn } from "@/lib/utils";

const badgeVariants = {
  default: "bg-surface-800 text-surface-300",
  primary: "bg-primary-500/20 text-primary-400",
  success: "bg-success/20 text-success",
  warning: "bg-warning/20 text-warning",
  error: "bg-error/20 text-error",
  info: "bg-info/20 text-info",
} as const;

const badgeSizes = {
  sm: "px-1.5 py-0.5 text-xs",
  md: "px-2 py-0.5 text-xs",
  lg: "px-3 py-1 text-sm",
} as const;

interface BadgeProps {
  variant?: keyof typeof badgeVariants;
  size?: keyof typeof badgeSizes;
  children: string;
  className?: string;
}

export function Badge({
  variant = "default",
  size = "md",
  children,
  className,
}: BadgeProps) {
  return (
    <span
      className={cn(
        "inline-flex items-center rounded-pill font-medium",
        badgeVariants[variant],
        badgeSizes[size],
        className
      )}
    >
      {children}
    </span>
  );
}
