import { TokenForm } from "./components/token-form"

export default function SettingsPage() {
    return (
        <div className="flex flex-col p-8 space-y-6">
            <h1 className="text-3xl font-semibold">Settings</h1>
            <div className="max-w-4xl">
                <TokenForm />
            </div>
        </div>
    )
}