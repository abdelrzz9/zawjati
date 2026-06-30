"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { motion } from "framer-motion";
import { Mail, Lock, Eye, EyeOff, Loader2, User } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useAuthStore } from "@/stores/auth-store";

const registerSchema = z.object({
  name: z.string().min(2, "Name must be at least 2 characters"),
  email: z.string().email("Invalid email address"),
  password: z.string().min(8, "Password must be at least 8 characters"),
  confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
  message: "Passwords do not match",
  path: ["confirmPassword"],
});

type RegisterForm = z.infer<typeof registerSchema>;

export default function RegisterPage() {
  const router = useRouter();
  const { register: registerUser, isLoading, error, clearError } = useAuthStore();
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<RegisterForm>({
    resolver: zodResolver(registerSchema),
  });

  const onSubmit = async (data: RegisterForm) => {
    try {
      await registerUser(data.name, data.email, data.password);
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
          <h1 className="text-3xl font-bold text-neutral-0">Create account</h1>
          <p className="text-surface-400 mt-2">Start your journey with Zawjati</p>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-5" onClick={clearError}>
          <Input
            label="Full name"
            type="text"
            placeholder="Enter your name"
            icon={<User size={18} aria-hidden={true} />}
            error={errors.name?.message}
            {...register("name")}
          />

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
            placeholder="Create a password"
            icon={<Lock size={18} aria-hidden={true} />}
            error={errors.password?.message}
            trailingIcon={
              <button type="button" onClick={() => setShowPassword(!showPassword)} aria-label={showPassword ? "Hide password" : "Show password"} className="text-surface-400 hover:text-neutral-0">
                {showPassword ? <EyeOff size={18} aria-hidden={true} /> : <Eye size={18} aria-hidden={true} />}
              </button>
            }
            {...register("password")}
          />

          <Input
            label="Confirm password"
            type={showConfirmPassword ? "text" : "password"}
            placeholder="Confirm your password"
            icon={<Lock size={18} aria-hidden={true} />}
            error={errors.confirmPassword?.message}
            trailingIcon={
              <button type="button" onClick={() => setShowConfirmPassword(!showConfirmPassword)} aria-label={showConfirmPassword ? "Hide password" : "Show password"} className="text-surface-400 hover:text-neutral-0">
                {showConfirmPassword ? <EyeOff size={18} aria-hidden={true} /> : <Eye size={18} aria-hidden={true} />}
              </button>
            }
            {...register("confirmPassword")}
          />

          {error && (
            <p className="text-error text-sm text-center">{error}</p>
          )}

          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? <Loader2 className="animate-spin" aria-hidden={true} /> : null}
            {isLoading ? "Creating account..." : "Create account"}
          </Button>
        </form>

        <p className="text-center text-sm text-surface-400">
          Already have an account?{" "}
          <Link href="/login" className="text-primary-400 hover:underline">
            Sign in
          </Link>
        </p>
      </motion.div>
    </div>
  );
}
