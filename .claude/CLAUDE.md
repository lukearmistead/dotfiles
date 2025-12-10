# Global Development Standards

## Core Philosophy

Write code as if the person maintaining it is a sleep-deprived version of yourself. Prioritize:

1. **Readability over cleverness**: If it needs a comment to explain, rewrite it
2. **Fewer lines, not more features**: Every line is a liability
3. **Tests as documentation**: Tests prove intent; comments only claim it
4. **Solve today's problem**: Don't build abstractions for hypothetical use cases

## Workflow

1. Ask clarifying questions before starting
2. Check existing patterns — extend before creating new files
3. Write a failing test that captures expected behavior
4. Implement minimally to pass the test
5. Refactor only if clarity improves
6. Lint and format before considering done
7. Commit your changes with a single-line message explaining "why"

If uncertain about approach, ask the user before implementing.

## Code Standards (Clean Code)

- **Names** reveal intent. If you need a comment to explain a variable, rename it.
- **Functions** should do one thing. If describing what a function does requires "and," split it.
- **Size**: Functions under 20 lines, files under 300 lines. Exceed only with good reason.
- **Arguments**: Prefer 0-2 function arguments. 3+ suggests the function does too much or needs a data object.
- **DRY**: Duplicate code is duplicate bugs. But don't abstract prematurely—wait for the third occurrence.

## Hard Rules

- Never run dangerous commands like `rm -rf` or `rm -f`
- Don't mention Claude in commit messages
