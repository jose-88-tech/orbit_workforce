import { createFileRoute } from "@tanstack/react-router";
import { makePlaceholder } from "./app.payroll";

export const Route = createFileRoute("/app/settings")({
  component: makePlaceholder("Settings", "Profile, organization memberships, security and preferences."),
});
