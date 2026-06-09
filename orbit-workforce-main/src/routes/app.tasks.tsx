import { createFileRoute } from "@tanstack/react-router";
import { ListTodo, Plus } from "lucide-react";

export const Route = createFileRoute("/app/tasks")({
  component: Tasks,
});

const cols = [
  { name: "Backlog", tone: "muted", tasks: [
    { t: "Q2 inventory audit", dept: "Warehouse", p: "Medium", pct: 0 },
    { t: "Onboard new contractors", dept: "HR", p: "Low", pct: 0 },
  ]},
  { name: "In Progress", tone: "primary", tasks: [
    { t: "Site B safety inspection", dept: "Construction", p: "High", pct: 65 },
    { t: "Quarterly compliance report", dept: "Admin", p: "High", pct: 40 },
    { t: "Driver schedule v3", dept: "Logistics", p: "Medium", pct: 80 },
  ]},
  { name: "Review", tone: "warning", tasks: [
    { t: "Updated PPE policy", dept: "Compliance", p: "High", pct: 95 },
  ]},
  { name: "Done", tone: "success", tasks: [
    { t: "May payroll attendance", dept: "Payroll", p: "High", pct: 100 },
    { t: "Team A monthly review", dept: "Operations", p: "Medium", pct: 100 },
  ]},
];

const priColor = { High: "bg-destructive/20 text-destructive", Medium: "bg-warning/20 text-warning", Low: "bg-success/20 text-success" } as const;

function Tasks() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h1 className="font-display text-3xl font-bold">Tasks</h1>
          <p className="text-muted-foreground text-sm mt-1">Department, team and individual task tracking.</p>
        </div>
        <button className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-gradient-primary text-primary-foreground font-semibold text-sm shadow-glow"><Plus className="size-4" /> New task</button>
      </div>

      <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {cols.map(col => (
          <div key={col.name} className="glass rounded-2xl p-4 min-h-64">
            <div className="flex items-center gap-2 mb-4">
              <ListTodo className="size-4 text-primary-glow" />
              <h3 className="font-display font-semibold">{col.name}</h3>
              <span className="ml-auto text-xs text-muted-foreground">{col.tasks.length}</span>
            </div>
            <div className="space-y-3">
              {col.tasks.map((t, i) => (
                <div key={i} className="rounded-xl bg-white/[0.04] p-3 hover:bg-white/[0.07] transition">
                  <div className="text-sm font-semibold">{t.t}</div>
                  <div className="text-xs text-muted-foreground mt-1">{t.dept}</div>
                  <div className="mt-3 flex items-center gap-2">
                    <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${priColor[t.p as keyof typeof priColor]}`}>{t.p}</span>
                    <div className="flex-1 h-1 rounded-full bg-white/10 overflow-hidden"><div className="h-full bg-gradient-primary" style={{ width: `${t.pct}%` }} /></div>
                    <span className="text-[10px] text-muted-foreground">{t.pct}%</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
