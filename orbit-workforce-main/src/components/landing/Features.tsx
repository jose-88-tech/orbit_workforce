import { Calendar, QrCode, Megaphone, ListTodo, HeartPulse, BarChart3, Shield, Users, Bell } from "lucide-react";

const features = [
  { icon: Calendar, title: "Enterprise Scheduling", desc: "Shifts, recurring patterns, department calendars, and personal planners." },
  { icon: QrCode, title: "QR + GPS Attendance", desc: "Verify clock-ins with QR, geofencing, and optional photo proof." },
  { icon: Megaphone, title: "Targeted Broadcasts", desc: "Reach departments, teams, or shifts with read-only compliance messages." },
  { icon: ListTodo, title: "Task Management", desc: "Department, team and individual tasks with progress analytics." },
  { icon: HeartPulse, title: "Burnout Prevention", desc: "Weekly hour monitoring and right-to-disconnect quiet mode." },
  { icon: BarChart3, title: "Realtime Analytics", desc: "Attendance trends, productivity, and burnout risk in one view." },
  { icon: Shield, title: "Role-based Security", desc: "Org-isolated tenancy, backend-enforced permissions, audit logs." },
  { icon: Users, title: "Workforce Directory", desc: "Search, filter and group employees by department, team, status." },
  { icon: Bell, title: "Smart Notifications", desc: "Critical alerts pierce quiet mode; routine ones queue politely." },
];

export function Features() {
  return (
    <section id="features" className="py-24 relative">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="max-w-2xl">
          <div className="text-xs uppercase tracking-[0.2em] text-primary-glow font-semibold mb-3">Platform</div>
          <h2 className="font-display text-4xl sm:text-5xl font-bold tracking-tight">Everything your workforce needs.<br /><span className="text-muted-foreground">Nothing they don't.</span></h2>
        </div>
        <div className="mt-14 grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {features.map((f) => (
            <div key={f.title} className="group glass rounded-2xl p-6 hover:bg-white/[0.06] transition-all hover:-translate-y-1">
              <div className="size-11 rounded-xl bg-gradient-primary flex items-center justify-center shadow-glow mb-5">
                <f.icon className="size-5 text-primary-foreground" />
              </div>
              <h3 className="font-display font-semibold text-lg mb-1.5">{f.title}</h3>
              <p className="text-sm text-muted-foreground leading-relaxed">{f.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
