---
name: PRD Template - Context-Rich with Validation Loops
description: |
  ## Purpose

  Template optimized for AI agents to implement features with sufficient context and self-validation capabilities to achieve working code through iterative refinement.

  ## Core Principles

  1. **Context is King**: Include ALL necessary documentation, examples, and caveats
  2. **Validation Loops**: Provide executable tests/lints the AI can run and fix
  3. **Information Dense**: Use keywords and patterns from the codebase
  4. **Progressive Success**: Start simple, validate, then enhance
---

---
prd_version: 1.0
feature_id: [3-digit-number]
feature_title: [kebab-case-feature-name]
estimated_complexity: [low|medium|high]
confidence_score: [percentage]
confidence_summary: "[Brief explanation of confidence level]"
pending_decisions: "[List key decisions needing user input, or 'none']"
context_priority: [critical|high|medium|low]
retrieval_tags: [tag1, tag2, tag3]
dependencies: [feature-id1, feature-id2]
implemented_at: null
---

## Problem Definition

### What Problem Are We Solving?
[2-3 sentences maximum describing the core problem]

### Who Is Affected?
- Primary users: [specific user segment]
- Impact: [quantifiable if possible]

### Why Now?
[Business driver or trigger event]

### Success Looks Like
- [ ] [Specific, measurable outcome]
- [ ] [User-observable change]
- [ ] [Business metric improvement]

## Context Assembly Guide

### Critical Context (Must Read First)
```yaml
- file: path/to/critical/file.ts
  relevance: CRITICAL
  sections: [lines 50-100, function processOrder]
  why: "Core business logic that must be preserved"
```

### Supporting Context (Read as Needed)
```yaml
- doc: docs/patterns/auth-flow.md
  relevance: MEDIUM
  why: "Follow this authentication pattern"
  
- url: https://docs.library.com/api
  relevance: LOW
  why: "Reference if using advanced features"
```

### Context Boundaries
- **In Scope**: [What this feature will change]
- **Out of Scope**: [What this feature will NOT touch]
- **Do Not Modify**: [Critical files/systems to avoid]

## Solution Approach

### Constraints

- [Technical: Language/framework requirements, performance targets]
- [Organizational: Coding standards, deployment restrictions]
- [Security/Compliance: Auth requirements, data protection needs]

### Project Commands

*These commands will be discovered during codebase analysis and populated by the create command:*

```bash
# Environment Setup
Install Dependencies: [project-specific install command]
Environment Setup: [additional setup steps if needed]
Start Development: [development server command]

# Validation (run after each phase)
Code Quality: [linting/formatting command] 
Type Safety: [type checking command, if applicable]
Run Tests: [test execution command]
Build Project: [build/compile command]

# Database (if applicable)
Database Migration: [migration command]
Database Seed: [test data setup command]

# Additional Project-Specific Commands
[Any other relevant commands discovered in the codebase]
```

*Note: The execute command should run these validation commands after each implementation phase to ensure code quality and catch issues early.*

### Solution Strategy

- [Architecture Pattern: Describe the approach (e.g., layered, modular, microservice)]
- [Integration Approach: Describe how this feature integrates with the current system architecture]
- [Justification: Brief rationale for why this approach fits given the constraints and scope]
- ...

### Building Block View

#### Components

```mermaid
graph LR
    User --> Component
    Component --> Hook
    Hook --> API
    API --> Database
```

#### Directory Map

```
/source_root
  /feature_area
    main_component          # NEW: Primary feature logic
    data_models            # MODIFY: Extend existing models
    business_logic         # NEW: Core processing logic
    integration_layer      # NEW: External service connections
  /shared
    utilities              # MODIFY: Add shared functions
    types                  # NEW: Shared type definitions
```

*Note: Actual paths and file names will be determined based on project conventions discovered during implementation.*

### Interface Specifications (Internal Changes Only)

*Include this section only when the feature involves changes to data structures, internal APIs, or core application interfaces.*

#### Data Storage Changes
```yaml
# Database/storage schema modifications
Table: primary_entity_table
  ADD COLUMN: new_field (data_type, constraints)
  MODIFY COLUMN: existing_field (new_constraints) 
  ADD INDEX: performance_index (fields)

Table: supporting_entity_table (NEW)
  id: primary_key
  related_id: foreign_key
  business_field: data_type, constraints
```

#### Internal API Changes
```yaml
# Application endpoints being added/modified
Endpoint: Feature Operation
  Method: HTTP_METHOD
  Path: /api/version/resource/operation
  Request:
    required_field: data_type, validation_rules
    optional_field: data_type, default_value
  Response:
    success:
      result_field: data_type
      metadata: object_structure
    error:
      error_code: string
      message: string
      details: object (optional)
```

#### Application Data Models
```pseudocode
# Core business objects being modified/created
ENTITY: PrimaryEntity (MODIFIED/NEW)
  FIELDS: 
    existing_field: data_type
    + new_field: data_type (NEW)
    ~ modified_field: updated_type (CHANGED)
  
  BEHAVIORS:
    existing_method(): return_type
    + new_method(parameters): return_type (NEW)
    ~ modified_method(): updated_return_type (CHANGED)

ENTITY: SupportingEntity (NEW)
  FIELDS: [field_definitions]
  BEHAVIORS: [method_definitions]
```

#### Integration Points
```yaml
# Where this feature connects to external systems
# (Full specifications in docs/interfaces/external/)

External_Service_Name:
  - doc: docs/interfaces/external/service-name.md
  - sections: [relevant_endpoints, data_formats]
  - integration: "Brief description of how systems connect"
  - critical_data: [data_elements_exchanged]
```

### Runtime View

#### Primary Flow: [Main User Action]
1. User triggers [action]
2. System validates [what]
3. Process executes [how]
4. Result displays [where]

```plantuml
@startuml
actor User
User -> UI : Apply promo code
UI -> PromoCodeController : POST /apply-code
PromoCodeController -> PromoCodeValidator : validate(code)
PromoCodeValidator --> PromoCodeController : ValidationResult
PromoCodeController -> OrderDiscountService : applyDiscount()
OrderDiscountService --> PromoCodeController : DiscountedOrder
PromoCodeController --> UI : Response
@enduml
```

#### Error Handling
- Invalid input: [specific error message]
- Network failure: [retry strategy]
- Business rule violation: [user feedback]

#### Complex Logic (if applicable)
```
ALGORITHM: Process Feature Request
INPUT: user_request, current_state
OUTPUT: processed_result

1. VALIDATE: input_parameters, user_permissions, system_state
2. TRANSFORM: raw_input -> structured_data
3. APPLY_BUSINESS_RULES: 
   - Check constraints and limits
   - Calculate derived values
   - Apply conditional logic
4. INTEGRATE: update_external_systems, notify_stakeholders
5. PERSIST: save_changes, log_activities
6. RESPOND: return_result, update_user_interface
```

### Deployment View

- **Environment**: [Where this runs - client/server/edge]
- **Configuration**: [Required env vars or settings]
- **Dependencies**: [External services or APIs needed]
- **Performance**: [Expected load, caching strategy]

### Cross-Cutting Concepts

- [Security: Authentication, authorization, encryption]
- [Error Handling: Global vs local strategies]
- [Performance Optimization: Caching, batching, async patterns]
- [i18n/L10n: Support for multi-language or regional content]
- [Logging/Auditing: System observability practices]

#### Implementation Patterns

Provide concrete examples from the codebase without being overly prescriptive:

*Note: Implementation specifics should follow established patterns in the codebase. The execute command will discover and apply appropriate patterns dynamically.*

##### Component Structure Pattern
```pseudocode
# Follow existing component organization in codebase
COMPONENT: FeatureComponent(properties)
  INITIALIZE: local_state, external_data_hooks
  
  HANDLE: loading_states, error_states, success_states
  
  RENDER: 
    IF loading: loading_indicator
    IF error: error_display(error_info)
    IF success: main_content(data, actions)
```

##### Data Processing Pattern
```pseudocode
# Business logic flow
FUNCTION: process_feature_operation(input, context)
  VALIDATE: input_format, permissions, preconditions
  AUTHORIZE: user_access, operation_permissions
  TRANSFORM: input_data -> business_objects
  EXECUTE: core_business_logic
  PERSIST: save_results, update_related_data
  RESPOND: success_result OR error_information
```

##### Error Handling Pattern
```pseudocode
# Error management approach
FUNCTION: handle_operation_errors(operation_result)
  CLASSIFY: error_type (validation, business_rule, system)
  LOG: error_details, context_information
  RECOVER: attempt_recovery_if_applicable
  RESPOND: 
    user_facing_message(safe_error_info)
    system_recovery_action(if_needed)
```

##### Test Pattern
```pseudocode
# Testing approach for behavior verification
TEST_SCENARIO: "Feature operates correctly under normal conditions"
  SETUP: valid_input_data, required_system_state
  EXECUTE: feature_operation_with_input
  VERIFY: 
    expected_output_produced
    system_state_updated_correctly
    side_effects_occurred_as_expected
    error_conditions_handled_properly
```

#### Integration Points

- [Where this connects to existing system]
- [Data flow in/out]
- [Events triggered/consumed]

### Architecture Decisions

1. **[Decision Name]**: [Choice made]
   - Rationale: [Why this over alternatives]
   - Trade-offs: [What we accept]

2. **[Decision Name]**: [Choice made]
   - Rationale: [Why this over alternatives]
   - Trade-offs: [What we accept]

### Quality Requirements

- [Performance: Specific, measurable targets that can be validated]
- [Usability: User experience requirements]
- [Security: Access control and data protection needs]
- [Reliability: Error handling and recovery requirements]

### Test Specifications

#### Critical Test Scenarios

**Scenario 1: Primary Happy Path**
```gherkin
Given: [System in valid initial state]
And: [Required preconditions met]
When: [User performs main action]
Then: [Expected outcome occurs]
And: [System state updated correctly]
And: [Appropriate feedback provided]
```

**Scenario 2: Validation Error Handling**
```gherkin
Given: [System ready for input]
When: [User provides invalid input]
Then: [Specific error message displayed]
And: [System state remains unchanged]
And: [User can recover/retry]
```

**Scenario 3: System Error Recovery**
```gherkin
Given: [Normal operation in progress]
When: [System error occurs during processing]
Then: [Error handled gracefully]
And: [User notified appropriately]
And: [System maintains data integrity]
```

**Scenario 4: Edge Case Handling**
```gherkin
Given: [Boundary condition scenario]
When: [Edge case operation attempted]
Then: [System handles edge case correctly]
And: [No unexpected behavior occurs]
```

#### Test Coverage Requirements
- **Business Logic**: All decision paths, calculation formulas, validation rules
- **User Interface**: All interaction flows, error states, loading states, accessibility  
- **Integration Points**: External service calls, data persistence, event handling
- **Edge Cases**: Boundary values, empty states, concurrent operations, system limits
- **Performance**: Response times under expected load, resource usage
- **Security**: Input validation, authorization checks, data protection

## Implementation Checklist

*This checklist provides a framework for implementation. The execute command should adapt phases and tasks based on discovered patterns and project structure.*

### Phase 1: Foundation Setup
- [ ] Read all CRITICAL context files
- [ ] Analyze existing codebase patterns for similar features
- [ ] Set up development environment and dependencies
- [ ] Create basic project structure following established conventions
- [ ] Define core data structures and interfaces
- [ ] **Validation**: Basic structure compiles/validates without errors

### Phase 2: Data Layer Implementation  
- [ ] Implement data storage changes (database migrations, models)
- [ ] Create data access layer (repositories, queries)
- [ ] Implement core business logic (validation, calculations)
- [ ] Add persistence mechanisms (save, update operations)
- [ ] **Validation**: Data operations work with test data

### Phase 3: Business Logic & API Layer
- [ ] Implement core business operations
- [ ] Add input validation and error handling
- [ ] Create internal API endpoints (if applicable)
- [ ] Integrate with external services (following interface specs)
- [ ] **Validation**: Business logic handles all specified scenarios

### Phase 4: User Interface (if applicable)
- [ ] Create user interface components
- [ ] Implement user interaction flows
- [ ] Add loading states and error displays
- [ ] Connect UI to business logic
- [ ] **Validation**: User flows work end-to-end

### Phase 5: Testing & Quality Assurance
- [ ] Implement unit tests for business logic
- [ ] Add integration tests for workflows
- [ ] Test error scenarios and edge cases
- [ ] Verify external service integration behavior
- [ ] **Validation**: All test scenarios pass

### Phase 6: Integration & Deployment
- [ ] Integrate with existing application components
- [ ] Update configuration and environment setup
- [ ] Verify deployment requirements
- [ ] Run full system validation
- [ ] **Final Validation**: Complete feature works in target environment

**Task Execution Notes:**
- Adapt task granularity based on feature complexity
- Follow TDD approach where specified in CLAUDE.md
- Run incremental validation after each phase
- Block on validation failures before proceeding

## Validation Checklist

### Level 1 – Structural Completeness

- [ ] Confirm all tasks in the implementation checklist are marked complete
- [ ] Verify each referenced file/module exists in the codebase
- [ ] Check that directory structure matches the target layout

### Level 2 – Interface and Data Contract Validation

- [ ] Verify interfaces match described method signatures
- [ ] Check that all schemas match examples in the document
- [ ] Validate that the correct models were extended/created

### Level 3 – Runtime Behavior Simulation

- [ ] Type checking is successful
- [ ] Code linting is successful
- [ ] Code formatting is consistent
- [ ] All tests pass
- [ ] Build completes without errors
- [ ] No runtime errors detected
- [ ] All automated test cases implemented and passing

### Level 4 – Quality Attribute Verification

- [ ] Performance: Does the system meet response time/load expectations?
- [ ] Security: Are all access controls and data protection mechanisms in place?
- [ ] Usability: Are user-facing messages clear and localized if needed?

### Level 5 – Design Alignment and Standards Compliance

- [ ] Review if the implementation follows team architectural patterns
- [ ] Confirm naming conventions, folder structure, and test coverage thresholds
- [ ] Identify any drift from previously made architectural decisions

## Anti-Patterns to Avoid

### Architecture Anti-Patterns
- ❌ Creating new architectural patterns when established ones exist
- ❌ Modifying unrelated systems "while you're there"
- ❌ Adding external dependencies without checking internal capabilities
- ❌ Changing core conventions without explicit approval
- ❌ Implementing business logic in presentation layer
- ❌ Tight coupling between independent components

### Integration Anti-Patterns
- ❌ Hardcoding external service URLs or credentials
- ❌ Ignoring rate limits and retry mechanisms for external services
- ❌ Exposing internal data structures to external systems
- ❌ Synchronous calls to external services in critical paths
- ❌ Assuming external services are always available

### Data Anti-Patterns
- ❌ Direct database access from presentation layer
- ❌ Storing business logic in database triggers or procedures
- ❌ Missing data validation at application boundaries
- ❌ Inconsistent data state across related entities
- ❌ Exposing database structure through API responses

### Testing Anti-Patterns
- ❌ Testing implementation details instead of behavior
- ❌ Skipping tests for "simple" functions
- ❌ Not testing error conditions and edge cases
- ❌ Over-mocking dependencies in integration tests
- ❌ Writing tests that depend on specific execution order
- ❌ Ignoring test failures or marking them as "flaky"

### Process Anti-Patterns
- ❌ Skipping validation steps to move faster
- ❌ Implementing without understanding existing patterns
- ❌ Making assumptions about user requirements
- ❌ Continuing implementation when blocked on critical decisions
- ❌ Deploying changes without proper testing
- ❌ Ignoring performance implications until production
