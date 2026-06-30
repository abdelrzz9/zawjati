import { describe, it, expect } from "vitest";
import { t, getDirection } from "@/lib/i18n";

describe("i18n", () => {
  describe("t", () => {
    it("returns English translation by default", () => {
      expect(t("app.name")).toBe("Zawjati");
    });

    it("returns Arabic translation", () => {
      expect(t("app.name", "ar")).toBe("زوجتي");
    });

    it("returns French translation", () => {
      expect(t("app.name", "fr")).toBe("Zawjati");
    });

    it("falls back to English for missing translations", () => {
      expect(t("nonexistent.key", "ar")).toBe("nonexistent.key");
    });

    it("returns key if no translation exists", () => {
      expect(t("unknown.key")).toBe("unknown.key");
    });
  });

  describe("getDirection", () => {
    it("returns rtl for Arabic", () => {
      expect(getDirection("ar")).toBe("rtl");
    });

    it("returns ltr for English", () => {
      expect(getDirection("en")).toBe("ltr");
    });

    it("returns ltr for French", () => {
      expect(getDirection("fr")).toBe("ltr");
    });
  });
});
