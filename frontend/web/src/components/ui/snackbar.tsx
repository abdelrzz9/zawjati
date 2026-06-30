import { toast } from "sonner";

export function showSuccess(message: string) {
  toast.success(message);
}

export function showError(message: string) {
  toast.error(message);
}

export function showInfo(message: string) {
  toast.info(message);
}

export function showWarning(message: string) {
  toast.warning(message);
}

export function showPromise<T>(
  promise: Promise<T>,
  messages: { loading: string; success: string; error: string }
) {
  toast.promise(promise, messages);
}

export { toast as snackbar };
