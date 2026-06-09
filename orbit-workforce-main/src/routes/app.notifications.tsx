import { createFileRoute } from "@tanstack/react-router";
import { makePlaceholder } from "./app.payroll";

export const Route = createFileRoute("/app/notifications")({
  component: makePlaceholder("Notifications", "Critical, high, normal and silent notification streams."),
});
