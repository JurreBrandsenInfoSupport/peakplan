import InboxTasksList from "./components/inbox-tasks-list";

export default function InboxPage() {
  return (
    <div className="container mx-auto px-8 py-10 space-y-8">
      <h1 className="font-semibold text-2xl">Inbox</h1>
      <InboxTasksList />
    </div>
  );
}
