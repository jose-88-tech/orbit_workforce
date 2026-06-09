import { createFileRoute, Link } from "@tanstack/react-router";
import { Sparkles, Mail, Lock, ArrowRight } from "lucide-react";

export const Route = createFileRoute("/login")({
  component: Login,
});

function Login() {
  return (
    <div className="min-h-screen bg-hero grid lg:grid-cols-2">
      <div className="hidden lg:flex relative overflow-hidden p-12 flex-col justify-between">
        <div className="absolute inset-0 grid-bg opacity-30" />
        <div className="absolute -bottom-32 -left-32 size-[500px] bg-gradient-glow blur-3xl" />
        <Link to="/" className="relative flex items-center gap-2">
          <div className="size-10 rounded-xl bg-gradient-primary flex items-center justify-center shadow-glow"><Sparkles className="size-5 text-primary-foreground" /></div>
          <span className="font-display font-bold text-xl">Org<span className="text-gradient">APP</span></span>
        </Link>
        <div className="relative">
          <h2 className="font-display text-4xl font-bold leading-tight">"Org APP gave us realtime visibility across 12 sites in a single quarter."</h2>
          <div className="mt-6 text-sm text-muted-foreground">Amara Okonkwo — COO, Northbridge Logistics</div>
        </div>
      </div>
      <div className="flex items-center justify-center p-6 sm:p-12">
        <div className="w-full max-w-md">
          <div className="lg:hidden mb-8 flex items-center gap-2">
            <div className="size-9 rounded-xl bg-gradient-primary flex items-center justify-center"><Sparkles className="size-4 text-primary-foreground" /></div>
            <span className="font-display font-bold text-lg">Org<span className="text-gradient">APP</span></span>
          </div>
          <h1 className="font-display text-3xl font-bold">Welcome back</h1>
          <p className="text-muted-foreground mt-2 text-sm">Sign in to access your workspace.</p>
          <form className="mt-8 space-y-4">
            <Field icon={Mail} type="email" placeholder="work@company.com" label="Work email" />
            <Field icon={Lock} type="password" placeholder="••••••••" label="Password" />
            <div className="flex items-center justify-between text-sm">
              <label className="flex items-center gap-2 text-muted-foreground"><input type="checkbox" className="accent-primary" /> Remember me</label>
              <a href="#" className="text-primary-glow hover:underline">Forgot?</a>
            </div>
            <Link to="/app" className="inline-flex items-center justify-center gap-2 w-full py-3 rounded-xl bg-gradient-primary text-primary-foreground font-semibold shadow-glow hover:opacity-95 transition">
              Sign in <ArrowRight className="size-4" />
            </Link>
          </form>
          <div className="mt-6 text-sm text-center text-muted-foreground">
            New to Org APP? <Link to="/register" className="text-primary-glow font-semibold hover:underline">Create an account</Link>
          </div>
        </div>
      </div>
    </div>
  );
}

function Field({ icon: Icon, label, ...rest }: { icon: any; label: string } & React.InputHTMLAttributes<HTMLInputElement>) {
  return (
    <label className="block">
      <span className="text-xs uppercase tracking-wider text-muted-foreground font-semibold">{label}</span>
      <div className="mt-1.5 relative">
        <Icon className="size-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-muted-foreground" />
        <input {...rest} className="w-full pl-10 pr-3 py-3 rounded-xl glass text-sm placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-primary" />
      </div>
    </label>
  );
}
