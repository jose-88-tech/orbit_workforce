import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/app/workforce")({
  component: Workforce,
});

const people = [
  { name: "Diego Hernández", role: "Team Lead", dept: "Construction", status: "online", attendance: "On shift" },
  { name: "Priya Raman", role: "Engineer", dept: "Operations", status: "online", attendance: "On shift" },
  { name: "Marcus Lee", role: "Operator", dept: "Logistics", status: "offline", attendance: "Late" },
  { name: "Sara Tominaga", role: "Coordinator", dept: "Admin", status: "online", attendance: "On shift" },
  { name: "Omar Said", role: "Driver", dept: "Logistics", status: "offline", attendance: "Off duty" },
  { name: "Yuki Kato", role: "Operator", dept: "Warehouse", status: "online", attendance: "On shift" },
  { name: "Amara Okonkwo", role: "Manager", dept: "Construction", status: "online", attendance: "On shift" },
  { name: "Liam Walsh", role: "Engineer", dept: "Operations", status: "offline", attendance: "Off duty" },
];

function Workforce() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="font-display text-3xl font-bold">Workforce Directory</h1>
        <p className="text-muted-foreground text-sm mt-1">Search and filter your entire organization.</p>
      </div>

      <div className="flex flex-wrap gap-2">
        {["All", "Construction", "Logistics", "Operations", "Warehouse", "Admin"].map((f, i) => (
          <button key={f} className={`px-4 py-2 rounded-xl text-sm font-semibold transition ${i === 0 ? "bg-gradient-primary text-primary-foreground shadow-glow" : "glass hover:bg-white/10"}`}>{f}</button>
        ))}
      </div>

      <div className="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
        {people.map(p => (
          <div key={p.name} className="glass rounded-2xl p-5 hover:bg-white/[0.06] transition">
            <div className="flex items-start gap-3">
              <div className="relative shrink-0">
                <div className="size-12 rounded-full bg-gradient-primary" />
                <span className={`absolute -bottom-0.5 -right-0.5 size-3.5 rounded-full border-2 border-background ${p.status === "online" ? "bg-success" : "bg-muted-foreground"}`} />
              </div>
              <div className="min-w-0 flex-1">
                <div className="font-display font-semibold truncate">{p.name}</div>
                <div className="text-xs text-muted-foreground">{p.role} · {p.dept}</div>
                <div className="mt-3 inline-flex text-[10px] font-bold px-2 py-1 rounded-full bg-accent/40 text-accent-foreground">{p.attendance}</div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
