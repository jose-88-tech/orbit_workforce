import { createFileRoute } from "@tanstack/react-router";
import { Calendar, Plus } from "lucide-react";

export const Route = createFileRoute("/app/activities")({
  component: Activities,
});

const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
const dates = Array.from({ length: 35 }, (_, i) => i - 2);

const statusFor = (n: number): "attended" | "late" | "absent" | "none" => {
  if (n <= 0 || n > 31) return "none";
  if (n === 12) return "late";
  if (n === 18) return "absent";
  if (n <= 28) return "attended";
  return "none";
};

const dot = { attended: "bg-success", late: "bg-warning", absent: "bg-destructive", none: "" } as const;

function Activities() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h1 className="font-display text-3xl font-bold">Activities & Scheduling</h1>
          <p className="text-muted-foreground text-sm mt-1">Company calendar, shifts, and attendance overlays.</p>
        </div>
        <button className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-gradient-primary text-primary-foreground font-semibold text-sm shadow-glow"><Plus className="size-4" /> Create shift</button>
      </div>

      <div className="grid lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 glass rounded-3xl p-5">
          <div className="flex items-center justify-between mb-5">
            <div className="flex items-center gap-2">
              <Calendar className="size-4 text-primary-glow" />
              <h2 className="font-display font-semibold">May 2026</h2>
            </div>
            <div className="flex items-center gap-3 text-xs text-muted-foreground">
              <span className="flex items-center gap-1.5"><span className="size-2 rounded-full bg-success" /> attended</span>
              <span className="flex items-center gap-1.5"><span className="size-2 rounded-full bg-warning" /> late</span>
              <span className="flex items-center gap-1.5"><span className="size-2 rounded-full bg-destructive" /> absent</span>
            </div>
          </div>
          <div className="grid grid-cols-7 gap-2 text-center text-xs text-muted-foreground mb-2">
            {days.map(d => <div key={d}>{d}</div>)}
          </div>
          <div className="grid grid-cols-7 gap-2">
            {dates.map((n, i) => {
              const s = statusFor(n);
              const isValid = n > 0 && n <= 31;
              return (
                <div key={i} className={`aspect-square rounded-xl p-2 text-sm relative ${isValid ? "glass hover:bg-white/10" : "opacity-30"} ${n === 29 ? "ring-2 ring-primary" : ""}`}>
                  {isValid && (
                    <>
                      <div className="font-semibold">{n}</div>
                      {s !== "none" && <span className={`absolute bottom-2 right-2 size-2 rounded-full ${dot[s]}`} />}
                    </>
                  )}
                </div>
              );
            })}
          </div>
        </div>

        <div className="space-y-4">
          <div className="glass rounded-3xl p-5">
            <h3 className="font-display font-semibold mb-3">Today's shifts</h3>
            <ul className="space-y-3">
              {[
                { t: "06:00–14:00", label: "Morning · Site B", n: 24 },
                { t: "14:00–22:00", label: "Afternoon · Site B", n: 22 },
                { t: "22:00–06:00", label: "Night · Warehouse", n: 12 },
              ].map((s, i) => (
                <li key={i} className="flex items-center gap-3 p-3 rounded-xl bg-white/[0.03]">
                  <div className="text-xs font-bold w-24 shrink-0">{s.t}</div>
                  <div className="flex-1 min-w-0">
                    <div className="text-sm font-semibold truncate">{s.label}</div>
                    <div className="text-xs text-muted-foreground">{s.n} assigned</div>
                  </div>
                </li>
              ))}
            </ul>
          </div>
          <div className="glass rounded-3xl p-5">
            <h3 className="font-display font-semibold mb-3">Recurring patterns</h3>
            <div className="space-y-2 text-sm">
              <div className="flex items-center justify-between"><span>Weekday mornings</span><span className="text-muted-foreground text-xs">Mon–Fri</span></div>
              <div className="flex items-center justify-between"><span>Weekend nights</span><span className="text-muted-foreground text-xs">Sat–Sun</span></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
