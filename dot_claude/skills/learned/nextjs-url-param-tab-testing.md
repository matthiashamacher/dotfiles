# Testing Next.js URL-Param-Driven Tabs

**Extracted:** 2026-06-09
**Context:** Next.js App Router components where active tab is derived from
`useSearchParams` (e.g. `searchParams.get('tab')`)

## Problem
Components that derive active tab from URL search params:
```js
const tabParam = useSearchParams().get('tab')
const activeTab = validTabs.includes(tabParam) ? tabParam : 'default'
```
Clicking a tab trigger calls `router.push('?tab=password')` — but in tests
`useSearchParams` is a static mock and never reflects the new URL. The tab
value never changes, so `onValueChange`-driven content never renders.

## Solution
Two separate concerns — test them independently:
1. **Tab navigation**: mock `useRouter`, click the trigger with `userEvent`,
   assert `router.push` was called with the correct `?tab=X` param.
2. **Tab content**: mock `useSearchParams` to return the desired param before
   rendering, then assert the content is visible.

## Example
```js
import userEvent from '@testing-library/user-event'
import { useSearchParams, useRouter } from 'next/navigation'

it('clicking tab calls router.push with correct param', async () => {
    const user = userEvent.setup()
    const mockPush = vi.fn()
    vi.mocked(useRouter).mockReturnValue({ push: mockPush, replace: vi.fn(), refresh: vi.fn(), back: vi.fn(), prefetch: vi.fn() })
    render(<MyComponent />)
    await user.click(screen.getByRole('tab', { name: 'Password' }))
    expect(mockPush).toHaveBeenCalledWith(expect.stringContaining('tab=password'))
})

it('renders password tab content when param is set', () => {
    vi.mocked(useSearchParams).mockReturnValue(new URLSearchParams('tab=password'))
    render(<MyComponent />)
    expect(screen.getByTestId('password-tab')).toBeInTheDocument()
})
```

## When to Use
Any Next.js component where tab/panel selection is stored in URL search params
(`searchParams.get`) rather than local `useState`.
