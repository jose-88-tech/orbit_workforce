import { Link } from "@tanstack/react-router";
import { ArrowRight, PlayCircle, Users, Clock, TrendingUp, Shield } from "lucide-react";

export function Hero() {
  return (
    <section className="relative pt-36 pb-24 overflow-hidden bg-hero">
      <div className="absolute inset-0 grid-bg opacity-40" />
      <div className="absolute -top-40 left-1/2 -translate-x-1/2 size-[800px] bg-gradient-glow blur-3xl pointer-events-none" />

      <div className="relative mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-4xl mx-auto">
          <div className="inline-flex items-center gap-2 glass rounded-full px-4 py-1.5 text-xs font-medium text-muted-foreground mb-6">
            <span className="size-1.5 rounded-full bg-success animate-pulse-glow" />
            Now with AI burnout prevention engine
          </div>
          <h1 className="font-display text-5xl sm:text-6xl lg:text-7xl font-bold tracking-tight text-gradient leading-[1.05]">
            The operating system<br /> for modern workforces
          </h1>
          <p className="mt-6 text-lg text-muted-foreground max-w-2xl mx-auto">
            Schedule shifts, verify attendance, broadcast across teams, and prevent burnout — all in one premium enterprise platform built for organizations of every size.
          </p>
          <div className="mt-10 flex flex-wrap items-center justify-center gap-3">
            <Link to="/register" className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-gradient-primary text-primary-foreground font-semibold shadow-glow hover:scale-[1.02] transition">
              Get Started Free <ArrowRight className="size-4" />
            </Link>
            <button className="inline-flex items-center gap-2 px-6 py-3 rounded-xl glass text-foreground font-semibold hover:bg-white/10 transition">
              <PlayCircle className="size-5" /> Book Demo
            </button>
          </div>
        </div>

        {/* Dashboard preview */}
        <div className="relative mt-20 max-w-6xl mx-auto">
          <div className="absolute inset-0 bg-gradient-primary blur-3xl opacity-30 -z-10" />
          <div className="glass-strong rounded-3xl p-2 sm:p-3 shadow-elevated">
            <div className="rounded-2xl bg-background/60 overflow-hidden">
              {/* Mock dashboard header */}
              <div className="flex items-center gap-2 px-4 py-3 border-b border-border">
                <div className="flex gap-1.5">
                  <span className="size-2.5 rounded-full bg-destructive/60" />
                  <span className="size-2.5 rounded-full bg-warning/60" />
                  <span className="size-2.5 rounded-full bg-success/60" />
                </div>
                <div className="ml-4 text-xs text-muted-foreground">orgapp.io / dashboard</div>
              </div>
              <div className="grid grid-cols-12 gap-3 p-4">
                {/* Sidebar */}
                <div className="hidden md:block col-span-2 space-y-2">
                  {["Dashboard","Activities","Workforce","Broadcasts","Tasks","Payroll"].map((l,i) => (
                    <div key={l} className={`text-xs px-3 py-2 rounded-lg ${i===0?"bg-gradient-primary text-primary-foreground":"text-muted-foreground hover:bg-white/5"}`}>{l}</div>
                  ))}
                </div>
                {/* Main */}
                <div className="col-span-12 md:col-span-10 space-y-3">
                  <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
                    {[
                      { icon: Users, label: "Active Workforce", value: "1,284", trend: "+12%" },
                      { icon: Clock, label: "Avg. Attendance", value: "96.4%", trend: "+2.1%" },
                      { icon: TrendingUp, label: "Productivity", value: "8.7", trend: "+0.4" },
                      { icon: Shield, label: "Compliance", value: "100%", trend: "stable" },
                    ].map(s => (
                      <div key={s.label} className="glass rounded-xl p-3">
                        <s.icon className="size-4 text-primary-glow mb-2" />
                        <div className="text-[10px] uppercase tracking-wider text-muted-foreground">{s.label}</div>
                        <div className="font-display text-xl font-bold">{s.value}</div>
                        <div className="text-[10px] text-success">{s.trend}</div>
                      </div>
                    ))}
                  </div>
                  <div className="glass rounded-xl p-4 h-48 relative overflow-hidden">
                    <div className="text-xs font-semibold mb-2">Workforce Activity — 7 days</div>
                    <svg viewBox="0 0 400 120" className="w-full h-32">
                      <defs>
                        <linearGradient id="grad" x1="0" x2="0" y1="0" y2="1">
                          <stop offset="0%" stopColor="oklch(0.72 0.2 285)" stopOpacity="0.7" />
                          <stop offset="100%" stopColor="oklch(0.72 0.2 285)" stopOpacity="0" />
                        </linearGradient>
                      </defs>
                      <path d="M0,80 C50,70 80,40 120,50 C160,60 200,20 240,30 C280,40 320,15 400,25 L400,120 L0,120 Z" fill="url(#grad)" />
                      <path d="M0,80 C50,70 80,40 120,50 C160,60 200,20 240,30 C280,40 320,15 400,25" stroke="oklch(0.72 0.2 285)" strokeWidth="2" fill="none" />
                    </svg>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
