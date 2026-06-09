import { Link, useRouterState } from "@tanstack/react-router";
import { LayoutDashboard, Calendar, Users, Megaphone, ListTodo, Wallet, BarChart3, ShieldCheck, Bell, Settings, Sparkles, Home, User } from "lucide-react";

const nav = [
  { to: "/app", label: "Dashboard", icon: LayoutDashboard, exact: true },
  { to: "/app/activities", label: "Activities", icon: Calendar },
  { to: "/app/workforce", label: "Workforce", icon: Users },
  { to: "/app/broadcasts", label: "Broadcasts", icon: Megaphone },
  { to: "/app/tasks", label: "Tasks", icon: ListTodo },
  { to: "/app/payroll", label: "Payroll", icon: Wallet },
  { to: "/app/analytics", label: "Analytics", icon: BarChart3 },
  { to: "/app/compliance", label: "Compliance", icon: ShieldCheck },
  { to: "/app/notifications", label: "Notifications", icon: Bell },
  { to: "/app/settings", label: "Settings", icon: Settings },
];

export function Sidebar() {
  const pathname = useRouterState({ select: s => s.location.pathname });
  return (
    <aside className="hidden lg:flex w-64 shrink-0 flex-col bg-sidebar border-r border-sidebar-border h-screen sticky top-0">
      <div className="p-5 flex items-center gap-2">
        <div className="size-9 rounded-xl bg-gradient-primary flex items-center justify-center shadow-glow"><Sparkles className="size-5 text-primary-foreground" /></div>
        <div>
          <div className="font-display font-bold leading-none">Org<span className="text-gradient">APP</span></div>
          <div className="text-[10px] text-muted-foreground mt-0.5">Acme Industries</div>
        </div>
      </div>
      <nav className="flex-1 px-3 pb-4 space-y-1 overflow-y-auto">
        {nav.map(n => {
          const active = n.exact ? pathname === n.to : pathname.startsWith(n.to);
          return (
            <Link key={n.to} to={n.to} className={`flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm transition ${active ? "bg-gradient-primary text-primary-foreground shadow-glow font-semibold" : "text-sidebar-foreground hover:bg-sidebar-accent"}`}>
              <n.icon className="size-4" />
              {n.label}
            </Link>
          );
        })}
      </nav>
      <div className="p-3 border-t border-sidebar-border">
        <div className="glass rounded-xl p-3 flex items-center gap-3">
          <div className="size-9 rounded-full bg-gradient-primary" />
          <div className="min-w-0">
            <div className="text-sm font-semibold truncate">Alex Morgan</div>
            <div className="text-[10px] text-muted-foreground">Organization Admin</div>
          </div>
        </div>
      </div>
    </aside>
  );
}

const mobileNav = [
  { to: "/app", label: "Home", icon: Home, exact: true },
  { to: "/app/activities", label: "Activities", icon: Calendar },
  { to: "/app/broadcasts", label: "Broadcast", icon: Megaphone },
  { to: "/app/settings", label: "Profile", icon: User },
];

export function MobileNav() {
  const pathname = useRouterState({ select: s => s.location.pathname });
  return (
    <nav className="lg:hidden fixed bottom-0 inset-x-0 z-40 glass-strong border-t border-border">
      <div className="grid grid-cols-4">
        {mobileNav.map(n => {
          const active = n.exact ? pathname === n.to : pathname.startsWith(n.to);
          return (
            <Link key={n.to} to={n.to} className={`flex flex-col items-center gap-1 py-3 text-[10px] font-medium transition ${active ? "text-primary-glow" : "text-muted-foreground"}`}>
              <n.icon className="size-5" />
              {n.label}
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
