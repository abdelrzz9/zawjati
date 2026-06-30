import Link from "next/link";

export default function NotFound() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-dark-background">
      <div className="text-center space-y-4">
        <h1 className="text-6xl font-bold text-primary-500">404</h1>
        <h2 className="text-2xl font-semibold text-neutral-0">
          Page not found
        </h2>
        <p className="text-surface-500 max-w-md">
          The page you're looking for doesn't exist or has been moved.
        </p>
        <Link
          href="/"
          className="inline-block px-6 py-3 bg-primary-500 text-white rounded-lg hover:bg-primary-600 transition-colors"
        >
          Go home
        </Link>
      </div>
    </div>
  );
}
