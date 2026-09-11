import { describe, expect, it } from 'vitest'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'

describe('admin content safety', () => {
  it('collects real event fields instead of publishing placeholder values', () => {
    const source = readFileSync(resolve(process.cwd(), 'client/src/pages/Admin.tsx'), 'utf8')

    expect(source).toContain('Verified venue')
    expect(source).toContain('Verified organizer')
    expect(source).toContain('Verified event description')
    expect(source).toContain('isPublished: eventPublished')
    expect(source).not.toContain("location: 'Venue unavailable'")
    expect(source).not.toContain("time: 'Time unavailable'")
    expect(source).not.toContain("description: 'Published from the authorized CampusPulse admin.'")
  })
})
