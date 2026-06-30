import { forwardRef, type InputHTMLAttributes, type ReactNode } from "react";
import { cn } from "@/lib/utils";

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  icon?: ReactNode;
  trailingIcon?: ReactNode;
  helperText?: string;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ className, label, error, icon, trailingIcon, helperText, ...props }, ref) => {
    return (
      <div className="w-full">
        {label && (
          <label className="block text-sm font-medium text-neutral-0 mb-1.5">
            {label}
          </label>
        )}
        <div className="relative">
          {icon && (
            <div className="absolute left-3 top-1/2 -translate-y-1/2 text-surface-400">
              {icon}
            </div>
          )}
          <input
            ref={ref}
            className={cn(
              "w-full h-10 rounded-md bg-dark-input border border-dark-border text-neutral-0 placeholder:text-surface-500 px-3 text-sm transition-colors duration-150",
              "focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-500/30",
              "disabled:opacity-50 disabled:cursor-not-allowed",
              icon && "pl-10",
              trailingIcon && "pr-10",
              error && "border-error focus:border-error focus:ring-error/30",
              className
            )}
            {...props}
          />
          {trailingIcon && (
            <div className="absolute right-3 top-1/2 -translate-y-1/2 text-surface-400">
              {trailingIcon}
            </div>
          )}
        </div>
        {error && <p className="mt-1 text-xs text-error">{error}</p>}
        {helperText && !error && (
          <p className="mt-1 text-xs text-surface-400">{helperText}</p>
        )}
      </div>
    );
  }
);

Input.displayName = "Input";
