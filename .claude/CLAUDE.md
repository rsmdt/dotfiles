# CLAUDE.md

Test-Driven Development (TDD) is mandatory for all code. Write tests before implementation.

## Agent Team Instructions

You have access to a team of specialist agents in ~/.claude/agents/*.md. Each agent has unique expertise and personality. Route requests based on complexity:

### Simple Tasks - Direct Routing
For straightforward tasks, use the appropriate specialist directly:
- **Errors/Bugs/Crashes** → the-site-reliability-engineer
- **Code implementation/fixes** → the-developer
- **Testing/Validation** → the-tester
- **Documentation** → the-technical-writer
- **Requirements clarification** → the-business-analyst
- **Security concerns** → the-security-engineer
- **Database/Query issues** → the-data-engineer
- **Deployment/CI/CD** → the-devops-engineer
- **Design questions** → the-architect

### Complex Tasks - Use the-chief
For multi-faceted requests, use the-chief to orchestrate:
- Multiple features or components
- Tasks requiring several specialists
- Strategic technology decisions
- Architecture planning
- Complex debugging requiring multiple perspectives

### Available Specialists
- **the-chief**: Orchestrator for complex tasks
- **the-architect**: System design and architecture
- **the-developer**: Code implementation
- **the-site-reliability-engineer**: Debugging and error diagnosis
- **the-tester**: Quality assurance and testing
- **the-business-analyst**: Requirements clarification
- **the-product-manager**: PRD creation
- **the-project-manager**: Task coordination
- **the-technical-writer**: Documentation
- **the-security-engineer**: Security audits
- **the-data-engineer**: Database and data pipelines
- **the-devops-engineer**: Deployment and CI/CD

### Important Notes
- Let each agent express their personality
- Use the-chief only when coordination is needed
- For ambiguous requests, start with the-business-analyst
- For errors, always use the-site-reliability-engineer first

## Development Process

### Planning and Communication
- Make sensible default assumptions when requirements are unclear, stating them inline
- Only ask questions when assumptions would be risky or multiple valid approaches exist
- Break work into small, testable units that can be verified independently
- Never commit code unless explicitly instructed by user

### Implementation Steps
1. Write a failing test that describes the desired behavior (Red)
2. Write the minimal code to make the test pass (Green)
3. Improve code structure while keeping tests green (Refactor)
4. Handle errors explicitly at each step
5. Include usage examples for non-trivial code

### Core Principles
- Start with the simplest solution that works, then iterate
- Single responsibility - each function/class does one thing well
- Keep functions under 20 lines when possible
- Separate business logic from I/O, UI, and framework code
- Validate inputs early and throw meaningful errors

## Testing

### Testing Approach
- One test at a time - focus on single behaviors
- Test behavior through public interfaces, not implementation
- Test edge cases: null values, empty collections, boundaries
- Keep tests independent and co-located with source files
- Use descriptive names: `it "returns 401 when user not authenticated"`

### Test Planning Format
```
it "calculates total with multiple items"
it "handles empty cart gracefully"
it "applies discount when threshold met"
it "throws error for negative quantities"
```

### Don't Test
- File imports or module loading
- Framework functionality
- Private implementation details
- External library behavior

## Code Quality and Naming

- Use intention-revealing names: `calculateTotalPrice()` not `calc()`
- Avoid abbreviations: prefer `userRepository` over `userRepo`
- Boolean functions use `is`, `has`, `can`, `should` prefixes
- Maintain consistent terminology throughout codebase
- Prefer self-documenting code over extensive comments
- Document the why, not the what - explain business logic and decisions

## Error Handling and Debugging

### Error Management
- Validate inputs at function entry with specific messages
- Create custom error types for different failures
- Include context about what failed and expected values
- Return generic messages to users, log details internally
- Provide fallbacks or clear recovery paths

### Debugging Support
- Add comprehensive logging with relevant state and context
- Log decision points and why code paths were taken
- Include timing information for performance analysis
- Make internal state inspectable for troubleshooting
- Use assertions to validate assumptions at runtime
- Write tests that reproduce and catch suspected bugs

## API and Data Design

### REST Patterns
- Use HTTP methods correctly: GET (read), POST (create), PUT (update), DELETE (remove)
- Resource-oriented URLs: `/api/v1/users` not `/api/v1/getUsers`
- Return appropriate status codes: 200, 400, 401, 404, 500
- Implement pagination for collections
- Version APIs in the URL path

### Data Handling
- Choose structures by use: Arrays for iteration, Maps for lookups, Sets for uniqueness
- Load data only when needed (lazy loading)
- Cache expensive computations and external calls
- Batch database operations when possible
- Use async/await for non-blocking I/O

## Performance

- Measure before optimizing - profile actual bottlenecks
- Write clear code first, optimize proven hot paths
- Use built-in methods like map, filter, reduce
- Minimize database calls with indexes and query limits
- Clean up resources to prevent memory leaks

## Security

### Input Protection
- Validate all inputs, even from internal sources
- Use parameterized queries to prevent SQL injection
- Sanitize outputs for target context (HTML, SQL, shell)
- Define allowed values (allowlist) rather than forbidden ones
- Restrict file uploads by type, size, and content

### Data Security
- Apply principle of least privilege for permissions
- Use secure, httpOnly cookies with proper expiration
- Hash passwords with bcrypt or similar
- Encrypt sensitive data with AES-256, use TLS for transport
- Store secrets in environment variables or vaults
- Audit security events and access attempts

## Priority Guidelines

When guidelines conflict, prioritize:
1. Security over performance
2. Tests over development speed
3. Readability over cleverness
4. Explicit over implicit

Make reasonable defaults based on common practices. Only escalate truly ambiguous business requirements.