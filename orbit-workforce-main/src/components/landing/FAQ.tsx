import { useState } from "react";
import { ChevronDown } from "lucide-react";

const faqs = [
  { q: "Does Org APP calculate payroll?", a: "No — we track attendance, approved hours and payout stages. Your existing payroll system handles the math." },
  { q: "Can one user belong to multiple organizations?", a: "Yes. The org switcher in the top navbar moves you between fully-isolated workspaces." },
  { q: "What attendance methods are supported?", a: "QR only, QR + GPS, or QR + GPS + Photo — configurable per organization and per shift." },
  { q: "How does burnout prevention work?", a: "We monitor weekly hours, validate minimum rest between shifts, and suppress non-urgent notifications in quiet mode." },
  { q: "Is it offline-capable?", a: "Yes. Attendance and key actions queue locally and sync when the device reconnects." },
];

export function FAQ() {
  const [open, setOpen] = useState(0);
  return (
    <section id="faq" className="py-24">
      <div className="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <div className="text-xs uppercase tracking-[0.2em] text-primary-glow font-semibold mb-3">FAQ</div>
          <h2 className="font-display text-4xl sm:text-5xl font-bold">Questions, answered</h2>
        </div>
        <div className="space-y-3">
          {faqs.map((f, i) => (
            <button key={f.q} onClick={() => setOpen(open === i ? -1 : i)} className="w-full text-left glass rounded-2xl p-5 hover:bg-white/[0.06] transition">
              <div className="flex items-center justify-between gap-4">
                <span className="font-display font-semibold">{f.q}</span>
                <ChevronDown className={`size-5 shrink-0 transition ${open === i ? "rotate-180" : ""}`} />
              </div>
              {open === i && <p className="mt-3 text-sm text-muted-foreground leading-relaxed">{f.a}</p>}
            </button>
          ))}
        </div>
      </div>
    </section>
  );
}
