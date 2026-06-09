import { createFileRoute } from "@tanstack/react-router";
import { Megaphone, Paperclip, Send, Pin } from "lucide-react";

export const Route = createFileRoute("/app/broadcasts")({
  component: Broadcasts,
});

const broadcasts = [
  { tag: "PINNED · Compliance", title: "Updated Q2 site safety guidelines", body: "All construction staff must review and acknowledge the updated PPE and lift-zone protocols before next shift.", time: "2h ago", ack: 87, pinned: true },
  { tag: "All Staff", title: "Payroll cycle changes for June", body: "Effective June 1, payroll attendance cuts off Sundays at midnight. Adjust personal planners accordingly.", time: "Yesterday", ack: 64 },
  { tag: "Logistics", title: "New route assignments published", body: "Drivers will receive personalized routes via the planner module by 5:00 AM tomorrow.", time: "2d ago", ack: 92 },
];

function Broadcasts() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h1 className="font-display text-3xl font-bold">Broadcasts</h1>
          <p className="text-muted-foreground text-sm mt-1">Read-only company-wide and targeted announcements.</p>
        </div>
      </div>

      <div className="grid lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-4">
          {broadcasts.map((b, i) => (
            <article key={i} className="glass rounded-2xl p-5">
              <div className="flex items-center gap-2 text-[10px] uppercase tracking-widest font-bold text-primary-glow">
                {b.pinned && <Pin className="size-3" />}
                {b.tag}
              </div>
              <h3 className="font-display text-lg font-semibold mt-2">{b.title}</h3>
              <p className="text-sm text-muted-foreground mt-2 leading-relaxed">{b.body}</p>
              <div className="mt-4 flex items-center justify-between text-xs text-muted-foreground">
                <span>{b.time}</span>
                <span>Acknowledged by <span className="text-foreground font-semibold">{b.ack}%</span></span>
              </div>
            </article>
          ))}
        </div>

        <aside className="glass rounded-2xl p-5 h-fit">
          <div className="flex items-center gap-2 mb-3">
            <Megaphone className="size-4 text-primary-glow" />
            <h3 className="font-display font-semibold">New broadcast</h3>
          </div>
          <select className="w-full px-3 py-2 rounded-xl glass text-sm mb-3">
            <option>Target: All staff</option>
            <option>Department: Construction</option>
            <option>Team A · Morning shift</option>
          </select>
          <input placeholder="Subject" className="w-full px-3 py-2 rounded-xl glass text-sm mb-3 placeholder:text-muted-foreground/60" />
          <textarea rows={5} placeholder="Message…" className="w-full px-3 py-2 rounded-xl glass text-sm placeholder:text-muted-foreground/60" />
          <div className="mt-3 flex items-center justify-between">
            <button className="text-xs flex items-center gap-1.5 text-muted-foreground hover:text-foreground"><Paperclip className="size-3.5" /> Attach</button>
            <button className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-gradient-primary text-primary-foreground font-semibold text-sm shadow-glow"><Send className="size-4" /> Send</button>
          </div>
        </aside>
      </div>
    </div>
  );
}
