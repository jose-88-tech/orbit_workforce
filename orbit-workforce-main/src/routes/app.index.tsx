import { createFileRoute } from "@tanstack/react-router";
import { Clock, LogOut, Calendar, AlertTriangle, Wallet, ListTodo, MapPin, Users, TrendingUp, HeartPulse, Megaphone, ChevronRight } from "lucide-react";

export const Route = createFileRoute("/app/")({
  component: Dashboard,
});

function Dashboard() {
  return (
    <div className="space-y-6">
      {/* Hero */}
      <div className="relative overflow-hidden rounded-3xl bg-gradient-primary p-6 sm:p-8 shadow-elevated">
        <div className="absolute inset-0 grid-bg opacity-20" />
        <div className="absolute -right-20 -top-20 size-72 bg-white/10 rounded-full blur-3xl" />
        <div className="relative grid lg:grid-cols-3 gap-6 items-center">
          <div className="lg:col-span-2">
            <div className="text-xs uppercase tracking-widest text-primary-foreground/70 font-semibold">Friday, May 29</div>
            <h1 className="font-display text-3xl sm:text-4xl font-bold text-primary-foreground mt-2">Good morning, Alex 👋</h1>
            <p className="text-primary-foreground/80 mt-2 max-w-lg">Your workforce is 94% on-shift today. Three departments need broadcast confirmations.</p>
            <div className="mt-5 flex flex-wrap gap-2">
              <button className="px-4 py-2 rounded-xl bg-background text-foreground font-semibold text-sm shadow-card hover:opacity-90 transition flex items-center gap-2"><Clock className="size-4" /> Clock In</button>
              <button className="px-4 py-2 rounded-xl glass-strong text-primary-foreground font-semibold text-sm transition flex items-center gap-2"><LogOut className="size-4" /> Clock Out</button>
              <button className="px-4 py-2 rounded-xl glass-strong text-primary-foreground font-semibold text-sm transition flex items-center gap-2"><Calendar className="size-4" /> Request Leave</button>
              <button className="px-4 py-2 rounded-xl glass-strong text-primary-foreground font-semibold text-sm transition flex items-center gap-2"><AlertTriangle className="size-4" /> Emergency Alert</button>
            </div>
          </div>
          <ActiveShiftCard />
        </div>
      </div>

      {/* Stats */}
      <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard icon={Users} label="Active Workforce" value="1,284" trend="+12% vs last week" tone="success" />
        <StatCard icon={Clock} label="On-time Today" value="96.4%" trend="+2.1%" tone="success" />
        <StatCard icon={TrendingUp} label="Productivity Index" value="8.7" trend="+0.4" tone="success" />
        <StatCard icon={HeartPulse} label="Burnout Risk" value="3 staff" trend="Needs attention" tone="warning" />
      </div>

      <div className="grid lg:grid-cols-3 gap-6">
        <AttendanceOverview />
        <TeamActivity />
        <PayrollCard />
        <BurnoutWarnings />
        <UpcomingSchedule />
        <BroadcastHighlights />
      </div>
    </div>
  );
}

function ActiveShiftCard() {
  return (
    <div className="glass-strong rounded-2xl p-5 text-primary-foreground">
      <div className="flex items-center justify-between">
        <div className="text-xs uppercase tracking-widest opacity-80">Active Shift</div>
        <span className="text-[10px] font-bold px-2 py-1 rounded-full bg-success/30 border border-success/40">LIVE</span>
      </div>
      <div className="font-display text-2xl font-bold mt-3">Morning · Site B</div>
      <div className="mt-1 text-sm opacity-80 flex items-center gap-1.5"><MapPin className="size-3.5" /> Zone 4 — Construction</div>
      <div className="mt-5 flex items-end justify-between">
        <div>
          <div className="text-[10px] uppercase opacity-70">Elapsed</div>
          <div className="font-display text-3xl font-bold">04:32</div>
        </div>
        <div className="text-right">
          <div className="text-[10px] uppercase opacity-70">Ends</div>
          <div className="font-display text-lg font-semibold">14:00</div>
        </div>
      </div>
    </div>
  );
}

function StatCard({ icon: Icon, label, value, trend, tone }: any) {
  const toneCls = tone === "warning" ? "text-warning" : "text-success";
  return (
    <div className="glass rounded-2xl p-5 hover:bg-white/[0.06] transition">
      <div className="flex items-center justify-between">
        <Icon className="size-5 text-primary-glow" />
        <span className={`text-xs font-semibold ${toneCls}`}>{trend}</span>
      </div>
      <div className="mt-4 text-xs uppercase tracking-wider text-muted-foreground">{label}</div>
      <div className="font-display text-3xl font-bold mt-1">{value}</div>
    </div>
  );
}

function Panel({ title, icon: Icon, children, action = "View all" }: any) {
  return (
    <div className="glass rounded-2xl p-5">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2">
          {Icon && <Icon className="size-4 text-primary-glow" />}
          <h3 className="font-display font-semibold">{title}</h3>
        </div>
        <button className="text-xs text-muted-foreground flex items-center hover:text-foreground transition">{action} <ChevronRight className="size-3" /></button>
      </div>
      {children}
    </div>
  );
}

function AttendanceOverview() {
  const items = [
    { dept: "Construction", on: 96, total: 120, tone: "success" },
    { dept: "Logistics", on: 72, total: 80, tone: "success" },
    { dept: "Operations", on: 41, total: 55, tone: "warning" },
    { dept: "Admin", on: 18, total: 22, tone: "success" },
  ];
  return (
    <Panel title="Attendance Overview" icon={Clock}>
      <div className="space-y-3">
        {items.map(i => {
          const pct = Math.round((i.on / i.total) * 100);
          return (
            <div key={i.dept}>
              <div className="flex items-center justify-between text-sm mb-1.5">
                <span className="font-medium">{i.dept}</span>
                <span className="text-muted-foreground">{i.on}/{i.total} · {pct}%</span>
              </div>
              <div className="h-1.5 rounded-full bg-white/5 overflow-hidden">
                <div className={`h-full ${i.tone === "warning" ? "bg-warning" : "bg-gradient-primary"}`} style={{ width: `${pct}%` }} />
              </div>
            </div>
          );
        })}
      </div>
    </Panel>
  );
}

function TeamActivity() {
  const events = [
    { name: "Diego H.", action: "Clocked in", time: "2m ago", tone: "success" },
    { name: "Priya R.", action: "Submitted task", time: "8m ago", tone: "primary" },
    { name: "Marcus L.", action: "Late arrival", time: "15m ago", tone: "warning" },
    { name: "Sara T.", action: "Leave approved", time: "23m ago", tone: "primary" },
  ];
  return (
    <Panel title="Team Activity" icon={Users}>
      <ul className="space-y-3">
        {events.map((e, i) => (
          <li key={i} className="flex items-center gap-3">
            <div className="size-9 rounded-full bg-gradient-primary shrink-0" />
            <div className="min-w-0 flex-1">
              <div className="text-sm font-medium truncate">{e.name}</div>
              <div className="text-xs text-muted-foreground">{e.action}</div>
            </div>
            <div className="text-[10px] text-muted-foreground">{e.time}</div>
          </li>
        ))}
      </ul>
    </Panel>
  );
}

function PayrollCard() {
  return (
    <Panel title="Payroll Status" icon={Wallet} action="Timeline">
      <div className="flex items-center justify-center py-2">
        <div className="relative size-32">
          <svg viewBox="0 0 36 36" className="size-full -rotate-90">
            <circle cx="18" cy="18" r="15.9155" fill="none" stroke="oklch(1 0 0 / 0.08)" strokeWidth="3" />
            <circle cx="18" cy="18" r="15.9155" fill="none" stroke="url(#pg)" strokeWidth="3" strokeDasharray="68, 100" strokeLinecap="round" />
            <defs>
              <linearGradient id="pg" x1="0" x2="1">
                <stop offset="0%" stopColor="oklch(0.62 0.22 280)" />
                <stop offset="100%" stopColor="oklch(0.72 0.2 310)" />
              </linearGradient>
            </defs>
          </svg>
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <div className="font-display text-2xl font-bold">68%</div>
            <div className="text-[10px] text-muted-foreground">period progress</div>
          </div>
        </div>
      </div>
      <div className="mt-2 text-center text-sm text-muted-foreground">Next payout in <span className="text-foreground font-semibold">12 days</span></div>
    </Panel>
  );
}

function BurnoutWarnings() {
  const list = [
    { name: "Marcus L.", risk: "62 hrs this week", level: "High" },
    { name: "Yuki K.", risk: "<8h rest interval", level: "Medium" },
    { name: "Omar S.", risk: "5 consecutive shifts", level: "Medium" },
  ];
  return (
    <Panel title="Burnout Warnings" icon={HeartPulse}>
      <ul className="space-y-3">
        {list.map((b, i) => (
          <li key={i} className="flex items-center justify-between p-3 rounded-xl bg-warning/10 border border-warning/20">
            <div>
              <div className="text-sm font-semibold">{b.name}</div>
              <div className="text-xs text-muted-foreground">{b.risk}</div>
            </div>
            <span className="text-[10px] font-bold px-2 py-1 rounded-full bg-warning/30 text-warning">{b.level}</span>
          </li>
        ))}
      </ul>
    </Panel>
  );
}

function UpcomingSchedule() {
  const items = [
    { time: "14:00", label: "Site B handover", who: "12 staff" },
    { time: "16:30", label: "Manager standup", who: "Department leads" },
    { time: "Tomorrow", label: "Safety training", who: "All construction" },
  ];
  return (
    <Panel title="Upcoming Schedule" icon={Calendar}>
      <ul className="space-y-3">
        {items.map((s, i) => (
          <li key={i} className="flex items-start gap-3">
            <div className="text-xs font-bold px-2 py-1 rounded-md bg-accent text-accent-foreground shrink-0 w-20 text-center">{s.time}</div>
            <div className="min-w-0">
              <div className="text-sm font-semibold">{s.label}</div>
              <div className="text-xs text-muted-foreground">{s.who}</div>
            </div>
          </li>
        ))}
      </ul>
    </Panel>
  );
}

function BroadcastHighlights() {
  return (
    <Panel title="Broadcast Highlights" icon={Megaphone}>
      <div className="space-y-3">
        <div className="p-3 rounded-xl bg-accent/20 border border-accent/30">
          <div className="text-xs font-bold text-primary-glow">PINNED · Compliance</div>
          <div className="text-sm font-semibold mt-1">Updated Q2 site safety guidelines</div>
          <div className="text-xs text-muted-foreground mt-1">Acknowledged by 87% · 2h ago</div>
        </div>
        <div className="p-3 rounded-xl glass">
          <div className="text-xs font-bold text-muted-foreground">All staff</div>
          <div className="text-sm font-semibold mt-1">Payroll cycle changes for June</div>
          <div className="text-xs text-muted-foreground mt-1">Posted yesterday</div>
        </div>
      </div>
    </Panel>
  );
}
