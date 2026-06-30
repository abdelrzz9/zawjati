"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { motion } from "framer-motion";
import { Mail, Lock, Eye, EyeOff, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useAuthStore } from "@/stores/auth-store";

const loginSchema = z.object({
  email: z.string().email("Invalid email address"),
  password: z.string().min(1, "Password is required"),
});

type LoginForm = z.infer<typeof loginSchema>;

export default function LoginPage() {
  const router = useRouter();
  const { login, isLoading, error, clearError } = useAuthStore();
  const [showPassword, setShowPassword] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginForm>({
    resolver: zodResolver(loginSchema),
  });

  const onSubmit = async (data: LoginForm) => {
    try {
      await login(data.email, data.password);
      router.push("/chat");
    } catch {
      // error is set in store
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md space-y-8"
      >
        <div className="text-center">
          <div className="flex justify-center mb-4">
            <div className="w-12 h-12 rounded-full bg-primary-500 flex items-center justify-center">
              <span className="text-white font-bold text-xl">Z</span>
            </div>
          </div>
          <h1 className="text-3xl font-bold text-neutral-0">Welcome back</h1>
          <p className="text-surface-400 mt-2">Sign in to continue with Zawjati</p>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-5" onClick={clearError}>
          <Input
            label="Email"
            type="email"
            placeholder="Enter your email"
            icon={<Mail size={18} aria-hidden={true} />}
            error={errors.email?.message}
            {...register("email")}
          />

          <Input
            label="Password"
            type={showPassword ? "text" : "password"}
            placeholder="Enter your password"
            icon={<Lock size={18} aria-hidden={true} />}
            error={errors.password?.message}
            trailingIcon={
              <button type="button" onClick={() => setShowPassword(!showPassword)} aria-label={showPassword ? "Hide password" : "Show password"} className="text-surface-400 hover:text-neutral-0">
                {showPassword ? <EyeOff size={18} aria-hidden={true} /> : <Eye size={18} aria-hidden={true} />}
              </button>
            }
            {...register("password")}
          />

          <div className="flex justify-end">
            <Link href="/forgot-password" className="text-sm text-primary-400 hover:underline">
              Forgot password?
            </Link>
          </div>

          {error && (
            <p className="text-error text-sm text-center">{error}</p>
          )}

          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? <Loader2 className="animate-spin" aria-hidden={true} /> : null}
            {isLoading ? "Signing in..." : "Sign in"}
          </Button>
        </form>

        <div className="relative">
          <div className="absolute inset-0 flex items-center">
            <div className="w-full border-t border-dark-border" />
          </div>
          <div className="relative flex justify-center text-sm">
            <span className="bg-dark-bg px-2 text-surface-400">Or continue with</span>
          </div>
        </div>

        <div className="grid grid-cols-3 gap-3">
          <Button type="button" variant="outline" className="w-full">Google</Button>
          <Button type="button" variant="outline" className="w-full">Apple</Button>
          <Button type="button" variant="outline" className="w-full">GitHub</Button>
        </div>

        <p className="text-center text-sm text-surface-400">
          Don&apos;t have an account?{" "}
          <Link href="/register" className="text-primary-400 hover:underline">
            Sign up
          </Link>
        </p>
      </motion.div>
    </div>
  );
}
