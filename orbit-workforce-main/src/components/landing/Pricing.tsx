import { Check } from "lucide-react";
import { Link } from "@tanstack/react-router";

const tiers = [
  {
    name: "Starter",
    price: "$0",
    blurb: "For small teams up to 15 employees.",
    features: ["QR attendance", "Basic scheduling", "1 organization", "Email support"],
    cta: "Start free",
    highlighted: false,
  },
  {
    name: "Business",
    price: "$8",
    suffix: "/user/mo",
    blurb: "Full workforce management for growing companies.",
    features: ["GPS + photo verification", "Broadcasts & tasks", "Burnout engine", "Realtime analytics", "Priority support"],
    cta: "Start 14-day trial",
    highlighted: true,
  },
  {
    name: "Enterprise",
    price: "Custom",
    blurb: "Compliance, SSO, multi-org, dedicated success.",
    features: ["Multi-org workspace", "SSO / SAML", "Audit logs & SLA", "Custom integrations", "Dedicated CSM"],
    cta: "Book demo",
    highlighted: false,
  },
];

export function Pricing() {
  return (
    <section id="pricing" className="py-24 relative">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-2xl mx-auto mb-14">
          <div className="text-xs uppercase tracking-[0.2em] text-primary-glow font-semibold mb-3">Pricing</div>
          <h2 className="font-display text-4xl sm:text-5xl font-bold tracking-tight">Simple plans that scale</h2>
        </div>
        <div className="grid md:grid-cols-3 gap-5">
          {tiers.map(t => (
            <div key={t.name} className={`relative rounded-3xl p-8 ${t.highlighted ? "bg-gradient-primary shadow-glow" : "glass"}`}>
              {t.highlighted && <div className="absolute -top-3 left-1/2 -translate-x-1/2 text-[10px] uppercase tracking-widest font-bold bg-background px-3 py-1 rounded-full border border-border">Most popular</div>}
              <div className={`text-sm font-semibold ${t.highlighted ? "text-primary-foreground/80" : "text-muted-foreground"}`}>{t.name}</div>
              <div className="mt-4 flex items-baseline gap-1">
                <span className={`font-display text-5xl font-bold ${t.highlighted ? "text-primary-foreground" : ""}`}>{t.price}</span>
                {t.suffix && <span className={`text-sm ${t.highlighted ? "text-primary-foreground/70" : "text-muted-foreground"}`}>{t.suffix}</span>}
              </div>
              <p className={`mt-2 text-sm ${t.highlighted ? "text-primary-foreground/80" : "text-muted-foreground"}`}>{t.blurb}</p>
              <ul className="mt-6 space-y-3">
                {t.features.map(f => (
                  <li key={f} className={`flex items-center gap-2 text-sm ${t.highlighted ? "text-primary-foreground" : ""}`}>
                    <Check className="size-4 shrink-0" /> {f}
                  </li>
                ))}
              </ul>
              <Link to="/register" className={`mt-8 block text-center font-semibold py-3 rounded-xl transition ${t.highlighted ? "bg-background text-foreground hover:opacity-90" : "glass-strong hover:bg-white/10"}`}>
                {t.cta}
              </Link>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
