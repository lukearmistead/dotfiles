# Global Development Standards

## Core Philosophy

Write code as if the person maintaining it is a sleep-deprived version of yourself. Prioritize:

1. **Readability over cleverness**: If it needs a comment to explain, rewrite it
2. **Emphasize brevity and simplicity**: Seek to limit or reduce the number of lines of code which much be maintained
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

If uncertain about approach, ask the user before implementing. Before changing existing code, state what you believe it does and why—silent misinterpretation is worse than a clarifying question.

## Code Standards

- **Names** reveal intent. If you need a comment to explain a variable, rename it.
- **Functions** should do one thing. If describing what a function does requires "and," split it.
- **Size**: Functions under 20 lines, files under 300 lines. Exceed only with good reason.
- **Arguments**: Prefer 0-2 function arguments. 3+ suggests the function does too much or needs a data object.
- **DRY**: Duplicate code is duplicate bugs. But don't abstract prematurely—wait for the third occurrence.
- **Types as guardrails**: Use strict typing. Prefer Pydantic models and dataclasses over raw dicts. Annotate class attributes at class scope, not just in `__init__`.

## Hard Rules

- Never run dangerous commands like `rm -rf` or `rm -f`
- Don't mention Claude in commit messages
- Never use em-dashes
- Always address the user by their first name "Luke"
