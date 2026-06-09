import { createFileRoute, Outlet } from "@tanstack/react-router";
import { Sidebar, MobileNav } from "@/components/dashboard/Sidebar";
import { Topbar } from "@/components/dashboard/Topbar";

export const Route = createFileRoute("/app")({
  component: AppShell,
});

function AppShell() {
  return (
    <div className="min-h-screen flex bg-background">
      <Sidebar />
      <div className="flex-1 flex flex-col min-w-0">
        <Topbar />
        <main className="flex-1 p-4 sm:p-6 lg:p-8 pb-24 lg:pb-8">
          <Outlet />
        </main>
      </div>
      <MobileNav />
    </div>
  );
}
