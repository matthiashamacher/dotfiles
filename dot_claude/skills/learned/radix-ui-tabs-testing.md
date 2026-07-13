# Radix UI Tabs Testing in jsdom

**Extracted:** 2026-06-09
**Context:** Vitest + jsdom + @testing-library/react projects using shadcn/ui or bare Radix UI

## Problem
Two independent failures when testing Radix UI `<Tabs>` components:
1. `fireEvent.click` on a `TabsTrigger` does NOT trigger `onValueChange` — the
   tab never switches. Call count stays 0.
2. Inactive `TabsContent` panels don't render their children (lazy mount) — even
   if the panel is in the DOM (with `hidden=""`), the child components aren't
   mounted until the tab becomes active for the first time.

## Solution
1. Use `userEvent.setup()` + `await user.click()` instead of `fireEvent.click`
   for any Radix-driven interaction (tabs, dropdowns, dialogs, etc.).
2. When asserting props/content of an inactive tab, click it first to activate
   it, then query the content.

## Example
```js
import userEvent from '@testing-library/user-event'

it('switches tab and renders content', async () => {
    const user = userEvent.setup()
    render(<MyTabComponent />)
    await user.click(screen.getByRole('tab', { name: 'Settings' }))
    expect(screen.getByTestId('settings-panel')).toBeInTheDocument()
})
```

## When to Use
Any test that clicks a Radix UI interactive element and expects a state change
or DOM mutation in response (tabs, accordion, dropdown, select, dialog, etc.).
