"use client";

import { useState } from "react";
import Link from "next/link";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { motion } from "framer-motion";
import { Mail, Loader2, ArrowLeft, CheckCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

const forgotSchema = z.object({
  email: z.string().email("Invalid email address"),
});

type ForgotForm = z.infer<typeof forgotSchema>;

export default function ForgotPasswordPage() {
  const [isLoading, setIsLoading] = useState(false);
  const [sent, setSent] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<ForgotForm>({
    resolver: zodResolver(forgotSchema),
  });

  const onSubmit = async () => {
    setIsLoading(true);
    // Simulate API call
    await new Promise((r) => setTimeout(r, 1500));
    setIsLoading(false);
    setSent(true);
  };

  if (sent) {
    return (
      <div className="min-h-screen flex items-center justify-center p-4">
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className="w-full max-w-md text-center space-y-6"
        >
          <div className="flex justify-center">
            <div className="w-16 h-16 rounded-full bg-success/20 flex items-center justify-center">
              <CheckCircle size={32} className="text-success" aria-hidden={true} />
            </div>
          </div>
          <h1 className="text-2xl font-bold text-neutral-0">Check your email</h1>
          <p className="text-surface-400">
            We&apos;ve sent a password reset link to your email. Please check your inbox.
          </p>
          <Link href="/login">
            <Button variant="secondary" icon={<ArrowLeft size={16} aria-hidden={true} />}>
              Back to sign in
            </Button>
          </Link>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md space-y-8"
      >
        <div className="text-center">
          <h1 className="text-3xl font-bold text-neutral-0">Forgot password?</h1>
          <p className="text-surface-400 mt-2">
            No worries, we&apos;ll send you a reset link
          </p>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
          <Input
            label="Email"
            type="email"
            placeholder="Enter your email"
            icon={<Mail size={18} aria-hidden={true} />}
            error={errors.email?.message}
            {...register("email")}
          />

          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? <Loader2 className="animate-spin" aria-hidden={true} /> : null}
            {isLoading ? "Sending..." : "Send reset link"}
          </Button>
        </form>

        <p className="text-center text-sm text-surface-400">
          <Link href="/login" className="inline-flex items-center gap-1 text-primary-400 hover:underline">
            <ArrowLeft size={14} aria-hidden={true} />
            Back to sign in
          </Link>
        </p>
      </motion.div>
    </div>
  );
}
