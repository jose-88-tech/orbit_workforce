import { HardHat, Truck, Warehouse, Stethoscope, Building2, GraduationCap } from "lucide-react";

const industries = [
  { icon: HardHat, name: "Construction", note: "GPS + QR with site-radius validation" },
  { icon: Truck, name: "Logistics", note: "Offline-first, route-aware attendance" },
  { icon: Warehouse, name: "Warehousing", note: "Shift density and burnout monitoring" },
  { icon: Stethoscope, name: "Healthcare", note: "Rotation scheduling and rest compliance" },
  { icon: Building2, name: "Corporate", note: "Hybrid schedules and project milestones" },
  { icon: GraduationCap, name: "Education", note: "Lightweight attendance for faculty" },
];

export function Industries() {
  return (
    <section id="industries" className="py-24 relative">
      <div className="absolute inset-x-0 top-1/2 -translate-y-1/2 h-96 bg-gradient-glow opacity-50 blur-3xl pointer-events-none" />
      <div className="relative mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-2xl mx-auto mb-14">
          <div className="text-xs uppercase tracking-[0.2em] text-primary-glow font-semibold mb-3">Industries</div>
          <h2 className="font-display text-4xl sm:text-5xl font-bold tracking-tight">Tuned for every workforce</h2>
          <p className="mt-4 text-muted-foreground">Select your industry on onboarding — modules and verification rules adapt automatically.</p>
        </div>
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {industries.map(i => (
            <div key={i.name} className="glass rounded-2xl p-6 flex items-start gap-4">
              <div className="size-12 rounded-xl bg-accent/40 flex items-center justify-center shrink-0">
                <i.icon className="size-6 text-primary-glow" />
              </div>
              <div>
                <div className="font-display font-semibold">{i.name}</div>
                <div className="text-sm text-muted-foreground mt-1">{i.note}</div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
