import { createFileRoute, Link } from "@tanstack/react-router";
import { Sparkles, Mail, Lock, User, Building2, ArrowRight, KeyRound } from "lucide-react";
import { useState } from "react";

export const Route = createFileRoute("/register")({
  component: Register,
});

function Register() {
  const [mode, setMode] = useState<"create" | "join">("create");
  return (
    <div className="min-h-screen bg-hero flex items-center justify-center p-4 sm:p-8">
      <div className="absolute inset-0 grid-bg opacity-30 pointer-events-none" />
      <div className="absolute top-1/3 left-1/2 -translate-x-1/2 size-[600px] bg-gradient-glow blur-3xl pointer-events-none" />
      <div className="relative w-full max-w-lg">
        <Link to="/" className="flex items-center justify-center gap-2 mb-8">
          <div className="size-10 rounded-xl bg-gradient-primary flex items-center justify-center shadow-glow"><Sparkles className="size-5 text-primary-foreground" /></div>
          <span className="font-display font-bold text-xl">Org<span className="text-gradient">APP</span></span>
        </Link>
        <div className="glass-strong rounded-3xl p-7 sm:p-9 shadow-elevated">
          <h1 className="font-display text-2xl sm:text-3xl font-bold">Create your account</h1>
          <p className="text-sm text-muted-foreground mt-2">Get your workspace running in under 60 seconds.</p>

          <div className="mt-6 grid grid-cols-2 gap-2 p-1 glass rounded-xl">
            {(["create","join"] as const).map(m => (
              <button key={m} onClick={() => setMode(m)} className={`text-sm font-semibold py-2 rounded-lg transition ${mode===m?"bg-gradient-primary text-primary-foreground shadow-glow":"text-muted-foreground"}`}>
                {m === "create" ? "Create Organization" : "Join with Code"}
              </button>
            ))}
          </div>

          <form className="mt-6 space-y-4">
            <Field icon={User} label="Full name" placeholder="Alex Morgan" />
            <Field icon={Mail} label="Work email" type="email" placeholder="alex@company.com" />
            <Field icon={Lock} label="Password" type="password" placeholder="••••••••" />
            {mode === "create" ? (
              <Field icon={Building2} label="Organization name" placeholder="Acme Industries" />
            ) : (
              <Field icon={KeyRound} label="Invite code" placeholder="ORG-EMP-4829" />
            )}
            <Link to="/app" className="inline-flex items-center justify-center gap-2 w-full py-3 rounded-xl bg-gradient-primary text-primary-foreground font-semibold shadow-glow hover:opacity-95 transition">
              Continue <ArrowRight className="size-4" />
            </Link>
          </form>
          <div className="mt-5 text-sm text-center text-muted-foreground">
            Already on Org APP? <Link to="/login" className="text-primary-glow font-semibold hover:underline">Sign in</Link>
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
