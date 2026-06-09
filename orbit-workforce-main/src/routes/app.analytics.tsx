import { createFileRoute } from "@tanstack/react-router";
import { makePlaceholder } from "./app.payroll";

export const Route = createFileRoute("/app/analytics")({
  component: makePlaceholder("Analytics", "Attendance, productivity and burnout-risk insights."),
});
