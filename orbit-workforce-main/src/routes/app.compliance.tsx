import { createFileRoute } from "@tanstack/react-router";
import { makePlaceholder } from "./app.payroll";

export const Route = createFileRoute("/app/compliance")({
  component: makePlaceholder("Compliance Center", "Training, safety guides and downloadable policies."),
});
