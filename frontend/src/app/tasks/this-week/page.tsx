import WeeklyTasksList from "./components/weekly-tasks-list";

export default function TodayPage() {
  return (
    <div className="container mx-auto px-8 py-10 space-y-8">
      <h1 className="font-semibold text-2xl">This week</h1>
      <WeeklyTasksList />
    </div>
  );
}
