import { Sparkles } from "lucide-react";

export function Footer() {
  return (
    <footer className="border-t border-border py-12 mt-12">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="grid md:grid-cols-4 gap-8">
          <div>
            <div className="flex items-center gap-2">
              <div className="size-9 rounded-xl bg-gradient-primary flex items-center justify-center"><Sparkles className="size-5 text-primary-foreground" /></div>
              <span className="font-display font-bold text-lg">Org<span className="text-gradient">APP</span></span>
            </div>
            <p className="mt-3 text-sm text-muted-foreground">The operating system for modern workforces.</p>
          </div>
          {[
            { title: "Product", items: ["Features", "Pricing", "Industries", "Changelog"] },
            { title: "Company", items: ["About", "Customers", "Careers", "Contact"] },
            { title: "Legal", items: ["Privacy", "Terms", "Security", "DPA"] },
          ].map(col => (
            <div key={col.title}>
              <div className="text-xs uppercase tracking-widest font-semibold text-muted-foreground mb-3">{col.title}</div>
              <ul className="space-y-2">
                {col.items.map(i => <li key={i}><a href="#" className="text-sm hover:text-foreground text-muted-foreground transition">{i}</a></li>)}
              </ul>
            </div>
          ))}
        </div>
        <div className="mt-12 pt-6 border-t border-border text-xs text-muted-foreground flex flex-wrap items-center justify-between gap-3">
          <div>© 2026 Org APP. All rights reserved.</div>
          <div>Built for enterprise workforces worldwide.</div>
        </div>
      </div>
    </footer>
  );
}
