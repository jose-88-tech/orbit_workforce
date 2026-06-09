import { Bell, Search, ChevronDown, Sun } from "lucide-react";

export function Topbar() {
  return (
    <header className="sticky top-0 z-30 glass-strong border-b border-border px-4 sm:px-6 py-3 flex items-center gap-3">
      <button className="glass rounded-xl px-3 py-2 flex items-center gap-2 text-sm">
        <div className="size-5 rounded-md bg-gradient-primary" />
        <span className="font-semibold hidden sm:inline">Acme Industries</span>
        <ChevronDown className="size-4 text-muted-foreground" />
      </button>
      <div className="flex-1 max-w-md relative hidden md:block">
        <Search className="size-4 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
        <input placeholder="Search people, shifts, broadcasts…" className="w-full pl-9 pr-3 py-2 rounded-xl glass text-sm placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-primary" />
      </div>
      <div className="ml-auto flex items-center gap-2">
        <button className="size-10 rounded-xl glass flex items-center justify-center hover:bg-white/10 transition"><Sun className="size-4" /></button>
        <button className="size-10 rounded-xl glass flex items-center justify-center hover:bg-white/10 transition relative">
          <Bell className="size-4" />
          <span className="absolute top-2 right-2 size-2 rounded-full bg-destructive animate-pulse-glow" />
        </button>
        <div className="size-10 rounded-full bg-gradient-primary shrink-0" />
      </div>
    </header>
  );
}
