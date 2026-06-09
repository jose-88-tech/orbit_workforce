import { createFileRoute } from "@tanstack/react-router";
import { Construction } from "lucide-react";

function makePlaceholder(title: string, desc: string) {
  return function Placeholder() {
    return (
      <div className="space-y-6">
        <div>
          <h1 className="font-display text-3xl font-bold">{title}</h1>
          <p className="text-muted-foreground text-sm mt-1">{desc}</p>
        </div>
        <div className="glass rounded-3xl p-12 text-center">
          <div className="size-14 mx-auto rounded-2xl bg-gradient-primary flex items-center justify-center shadow-glow mb-4">
            <Construction className="size-6 text-primary-foreground" />
          </div>
          <h2 className="font-display text-xl font-semibold">Coming next</h2>
          <p className="text-sm text-muted-foreground mt-2 max-w-md mx-auto">
            This module is part of the full build. The dashboard shell, navigation, and key surfaces are ready — wire data and flows in the next iteration.
          </p>
        </div>
      </div>
    );
  };
}

export { makePlaceholder };

export const Route = createFileRoute("/app/payroll")({
  component: makePlaceholder("Payroll Tracking", "Attendance accumulation, approved hours, payout stages."),
});
