import TodayTasksList from "./components/today-tasks-list";

export default function TodayPage() {
    return (
        <div className="container mx-auto px-8 py-10 space-y-8">
            <h1 className="font-semibold text-2xl">Today</h1>
            <TodayTasksList />
        </div>
    )
}