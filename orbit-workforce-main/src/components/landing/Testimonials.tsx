const testimonials = [
  { quote: "Org APP replaced three tools and gave us realtime visibility across 12 sites.", name: "Amara Okonkwo", role: "COO, Northbridge Logistics" },
  { quote: "The burnout engine flagged scheduling conflicts our managers were missing.", name: "Diego Hernández", role: "VP People, Cinder Health" },
  { quote: "QR + GPS attendance ended timesheet disputes overnight.", name: "Priya Raman", role: "Ops Director, Vertex Build" },
];

export function Testimonials() {
  return (
    <section className="py-24 relative">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-2xl mx-auto mb-14">
          <div className="text-xs uppercase tracking-[0.2em] text-primary-glow font-semibold mb-3">Customers</div>
          <h2 className="font-display text-4xl sm:text-5xl font-bold tracking-tight">Trusted by operations leaders</h2>
        </div>
        <div className="grid md:grid-cols-3 gap-5">
          {testimonials.map(t => (
            <figure key={t.name} className="glass rounded-2xl p-7">
              <blockquote className="font-display text-lg leading-snug">"{t.quote}"</blockquote>
              <figcaption className="mt-6 flex items-center gap-3">
                <div className="size-10 rounded-full bg-gradient-primary" />
                <div>
                  <div className="text-sm font-semibold">{t.name}</div>
                  <div className="text-xs text-muted-foreground">{t.role}</div>
                </div>
              </figcaption>
            </figure>
          ))}
        </div>
      </div>
    </section>
  );
}
