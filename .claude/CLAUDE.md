# CLAUDE.md

## Implementation Guidelines

### Code Structure

- **Start with the simplest solution** that works, then iterate
- **Single responsibility** - Each function/class should do one thing well
- **Small functions** - Keep functions under 20 lines when possible
- **Clear separation** - Separate business logic from I/O, UI, and framework code
- **Fail fast** - Validate inputs early and throw meaningful errors

### Implementation Process

1. **Plan before coding** - Outline the approach in comments first
2. **Implement incrementally** - Build in small, testable pieces
3. **Handle errors explicitly** - Don't ignore potential failure points
4. **Add logging/debugging** - Include helpful output for troubleshooting
5. **Review and clean up** - Remove dead code, improve naming, add docs

### Naming and Clarity

- **Use intention-revealing names** - Code should read like well-written prose
- **Avoid abbreviations** - Prefer `userRepository` over `userRepo`
- **Boolean functions** - Use `is`, `has`, `can`, `should` prefixes
- **Consistent terminology** - Use the same words for the same concepts

### Error Handling

- **Explicit error types** - Create custom exceptions when appropriate
- **Meaningful messages** - Include context about what failed and why
- **Fail gracefully** - Provide fallbacks or clear recovery paths
- **Log errors properly** - Include stack traces and relevant state

### Documentation

- **Self-documenting code** - Prefer clear code over extensive comments
- **Document the why** - Explain complex business logic and decisions
- **Keep docs current** - Update documentation when changing behavior

## Testing Guidelines

**IMPORTANT: Test-Driven Development (TDD) is mandatory for all code.**

### Test Planning

Before writing any tests, list the behaviors and edge cases that must be verified. Include a short explanation of the intent behind each test. Once confirmed, write the actual tests based on this plan.

When updating tests after code changes:

- Only modify tests affected by the new interface or logic
- Avoid unnecessary mocks or abstractions unless critical
- Always re-run the full test suite and verify all tests pass

### TDD Process

1. **Red**: Write a failing test that describes the desired behavior
2. **Green**: Write the minimal code to make the test pass
3. **Refactor**: Improve code structure while keeping tests green

### Testing Rules

- **Always write the test first** - Never write code without a failing test
- **One test at a time** - Focus on a single behavior per test cycle
- **Use descriptive test names** - Format: `it "[expected_behavior] when [condition]"`
- **Test edge cases** - Include null values, empty collections, boundary conditions
- **Keep tests independent** - Each test should run in isolation
- **Write the simplest code** that makes the test pass, then refactor

### Test-First Guidelines

- Start with the test name that describes the expected behavior
- Write assertions first, then work backwards to setup
- Make tests fail for the right reason before implementing
- If a test passes immediately, either delete it or make it more specific

## Debugging and Troubleshooting Support

### Code Analysis for Debugging

- **Add comprehensive logging** - Include relevant state and context in log messages
- **Use assertions liberally** - Add runtime checks for expected conditions
- **Create debug helpers** - Write functions that dump object state or execution flow
- **Add conditional debugging** - Include debug flags to enable/disable verbose output
- **Suggest debugging approaches** - Recommend specific techniques based on the problem type

### Debugging-Friendly Code Patterns

- **Make state visible** - Provide methods to inspect internal object state
- **Log decision points** - Record why certain code paths were taken
- **Include timing information** - Add timestamps to understand execution flow
- **Validate assumptions** - Add checks that fail fast when assumptions are wrong
- **Use meaningful variable names** - Make code self-documenting for easier analysis

### Troubleshooting Recommendations

- **Suggest isolating problems** - Recommend breaking complex operations into smaller, testable parts
- **Recommend logging strategies** - Advise on what information to capture for different types of issues
- **Propose minimal reproduction cases** - Help create simplified versions that demonstrate problems
- **Identify common pitfalls** - Point out typical issues in similar code patterns
- **Suggest testing approaches** - Recommend unit tests that would catch the suspected issue

## Performance Guidelines

### Performance-First Mindset

- **Measure before optimizing** - Profile and identify actual bottlenecks
- **Choose appropriate data structures** - Arrays for iteration, Maps for lookups, Sets for uniqueness
- **Lazy loading** - Only load data when actually needed
- **Cache strategically** - Cache expensive computations and external calls
- **Batch operations** - Group database queries and API calls when possible

### Common Optimizations

- **Avoid premature optimization** - Write clear code first, optimize hot paths later
- **Minimize loops** - Use built-in methods like `map`, `filter`, `reduce` when appropriate
- **Database efficiency** - Use indexes, limit result sets, avoid N+1 queries
- **Memory management** - Clean up resources, avoid memory leaks, use weak references
- **Asynchronous operations** - Don't block on I/O, use proper async patterns

## Security Guidelines

### Input Validation and Sanitization

- **Validate all inputs** - Never trust user data, even from internal sources
- **Sanitize outputs** - Escape data for the target context (HTML, SQL, shell)
- **Use allowlists over blocklists** - Define what's allowed rather than what's forbidden
- **Parameterized queries** - Always use prepared statements for database queries
- **File upload restrictions** - Validate file types, sizes, and scan for malware

### Authentication and Authorization

- **Principle of least privilege** - Grant minimum permissions necessary
- **Secure session management** - Use secure, httpOnly cookies with proper expiration
- **Multi-factor authentication** - Implement when handling sensitive data
- **API security** - Use proper authentication tokens, rate limiting, and CORS
- **Audit logging** - Log security-relevant events with sufficient detail

### Data Protection

- **Encrypt sensitive data** - Both at rest and in transit using strong algorithms
- **Secure configuration** - Keep secrets in environment variables or secure vaults
- **HTTPS everywhere** - Use TLS for all communications
- **Regular updates** - Keep dependencies and systems patched
- **Error handling** - Don't leak sensitive information in error messages
