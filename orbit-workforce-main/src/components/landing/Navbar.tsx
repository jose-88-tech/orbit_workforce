import { Link } from "@tanstack/react-router";
import { ArrowRight, Sparkles } from "lucide-react";

export function Navbar() {
  return (
    <header className="fixed top-0 inset-x-0 z-50">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 mt-4">
        <nav className="glass-strong rounded-2xl px-4 sm:px-6 py-3 flex items-center justify-between shadow-card">
          <Link to="/" className="flex items-center gap-2 group">
            <div className="size-9 rounded-xl bg-gradient-primary flex items-center justify-center shadow-glow">
              <Sparkles className="size-5 text-primary-foreground" />
            </div>
            <span className="font-display font-bold text-lg tracking-tight">Org<span className="text-gradient">APP</span></span>
          </Link>
          <div className="hidden md:flex items-center gap-8 text-sm text-muted-foreground">
            <a href="#features" className="hover:text-foreground transition">Features</a>
            <a href="#industries" className="hover:text-foreground transition">Industries</a>
            <a href="#pricing" className="hover:text-foreground transition">Pricing</a>
            <a href="#faq" className="hover:text-foreground transition">FAQ</a>
          </div>
          <div className="flex items-center gap-2">
            <Link to="/login" className="hidden sm:inline-flex text-sm font-medium px-4 py-2 rounded-lg hover:bg-white/5 transition">Login</Link>
            <Link to="/register" className="inline-flex items-center gap-1.5 text-sm font-semibold px-4 py-2 rounded-lg bg-gradient-primary text-primary-foreground shadow-glow hover:opacity-95 transition">
              Get Started <ArrowRight className="size-4" />
            </Link>
          </div>
        </nav>
      </div>
    </header>
  );
}
