import { format, formatDistanceToNow, formatRelative } from "date-fns";
import { arSA, enUS, fr } from "date-fns/locale";

const locales: Record<string, Locale> = {
  en: enUS,
  ar: arSA,
  fr: fr,
};

export function formatDate(date: string | Date, locale: string = "en"): string {
  const d = typeof date === "string" ? new Date(date) : date;
  const loc = locales[locale] || enUS;
  return format(d, "PP", { locale: loc });
}

export function formatRelativeTime(
  date: string | Date,
  locale: string = "en",
): string {
  const d = typeof date === "string" ? new Date(date) : date;
  const loc = locales[locale] || enUS;
  return formatDistanceToNow(d, { addSuffix: true, locale: loc });
}

export function formatDateTime(
  date: string | Date,
  locale: string = "en",
): string {
  const d = typeof date === "string" ? new Date(date) : date;
  const loc = locales[locale] || enUS;
  return format(d, "PPp", { locale: loc });
}

export function formatNumber(
  num: number,
  locale: string = "en",
): string {
  try {
    return new Intl.NumberFormat(locale === "ar" ? "ar-SA" : locale === "fr" ? "fr-FR" : "en-US").format(num);
  } catch {
    return num.toString();
  }
}
