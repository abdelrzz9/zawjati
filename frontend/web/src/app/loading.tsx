export default function Loading() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-dark-background">
      <div className="text-center space-y-4">
        <div className="w-12 h-12 border-4 border-primary-500 border-t-transparent rounded-full animate-spin mx-auto" />
        <p className="text-surface-500">Loading...</p>
      </div>
    </div>
  );
}
