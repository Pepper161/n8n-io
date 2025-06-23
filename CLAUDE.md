# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

n8n is a workflow automation platform that combines the flexibility of code with the speed of no-code. It's built as a TypeScript monorepo using pnpm workspaces, with 400+ integrations, native AI capabilities, and a fair-code license.

## Essential Commands

### Development Setup
```bash
# Install dependencies (required pnpm >=10.2.1, Node.js >=22.16)
pnpm install

# Build all packages
pnpm build

# Start full development environment
pnpm dev

# Start backend only (for API/core development)
pnpm dev:be

# Start frontend only (for UI development)  
pnpm dev:fe

# Start with AI/LangChain focus
pnpm dev:ai
```

### Testing
```bash
# Run all tests
pnpm test

# Run specific test suites
pnpm test:backend
pnpm test:frontend
pnpm test:nodes

# E2E testing
pnpm dev:e2e                    # Interactive Cypress tests
cypress/pnpm test:e2e:all       # Headless E2E tests
```

### Code Quality
```bash
# Lint all packages
pnpm lint

# Fix linting issues
pnpm lintfix

# Format code with Biome
pnpm format

# Type checking
pnpm typecheck
```

### Package-Specific Commands
```bash
# Start n8n server directly
pnpm start

# Start with tunnel (for webhook testing)
pnpm start:tunnel

# Run specific worker process
pnpm worker

# Test webhook endpoints
pnpm webhook
```

## Architecture Overview

### Monorepo Structure
The codebase is organized into focused packages under `/packages/`:

**Core Runtime:**
- `cli/` - Main CLI application and Express server (`n8n` command)
- `core/` - Workflow execution engine and node functions
- `workflow/` - Workflow definitions, data proxy, and expression evaluator
- `nodes-base/` - 400+ built-in node integrations

**Frontend:**
- `frontend/editor-ui/` - Vue.js workflow editor interface
- `@n8n/design-system/` - Shared UI components and design tokens
- `@n8n/stores/` - Pinia state management stores

**Backend Infrastructure:**
- `@n8n/db/` - TypeORM entities, repositories, and migrations
- `@n8n/api-types/` - Shared API interfaces and DTOs
- `@n8n/config/` - Configuration management with class-validator
- `@n8n/permissions/` - RBAC authorization system

**AI Integration:**
- `@n8n/nodes-langchain/` - LangChain-based AI nodes (50+ nodes)
- `@n8n/ai-workflow-builder/` - AI-powered workflow generation service

### Key Entry Points
- **CLI**: `/packages/cli/bin/n8n` - Main executable
- **Server**: `/packages/cli/src/server.ts` - Express app initialization
- **Workflow Engine**: `/packages/core/src/WorkflowExecute.ts` - Core execution logic
- **Frontend**: `/packages/frontend/editor-ui/src/main.ts` - Vue app entry

### Build System
- **Turbo** for monorepo builds with dependency graph optimization
- **TypeScript** strict mode throughout (no `ts-ignore` allowed)
- **pnpm workspaces** for dependency management
- **Biome** for fast formatting (replaces Prettier)

## Development Patterns

### Node Development
- All nodes inherit from `INodeType` interface
- Use `NodeExecuteFunctions` from `n8n-core` for API calls
- Implement `execute()` method for processing
- Use credential helpers for authentication
- Follow naming convention: `[Service][Action].node.ts`

### Database Operations
- TypeORM with SQLite/PostgreSQL/MySQL support
- Use repository pattern via `@n8n/db` package
- Migrations in `/packages/@n8n/db/src/migrations/`
- Entities use decorators for validation and relationships

### Frontend Development
- Vue 3 with Composition API
- Pinia stores for state management
- Element Plus UI components
- TypeScript strict mode
- Tailwind CSS for styling

### Testing Strategy
- Jest for unit tests (business logic)
- Cypress for E2E tests (user workflows)
- Workflow tests for node integrations
- Performance tests via benchmark package

## Configuration

### Environment Variables
Configuration is managed through `@n8n/config` package using class-validator:
- `N8N_HOST` - Server host (default: localhost)
- `N8N_PORT` - Server port (default: 5678)
- `DB_TYPE` - Database type (sqlite/postgres/mysql)
- `N8N_ENCRYPTION_KEY` - For credential encryption
- `WEBHOOK_URL` - Base URL for webhooks

### Development Configuration
- `.vscode/` directory contains debug configuration
- `turbo.json` defines build pipeline and caching
- `biome.jsonc` contains formatting rules
- `jest.config.js` at root for global test configuration

## Common Development Tasks

### Adding a New Node
1. Use node-dev CLI: `pnpm --filter=n8n-node-dev new`
2. Implement in `packages/nodes-base/nodes/[Service]/`
3. Add credentials in `packages/nodes-base/credentials/`
4. Write tests following existing patterns
5. Update node index file

### Adding API Endpoints
1. Create DTOs in `@n8n/api-types`
2. Add controller in `packages/cli/src/controllers/`
3. Register routes in `packages/cli/src/server.ts`
4. Implement service logic
5. Add proper error handling and validation

### Database Changes
1. Create migration in `@n8n/db/src/migrations/`
2. Update corresponding entity in `@n8n/db/src/entities/`
3. Test migration up/down scenarios
4. Update repository methods if needed

## Security Considerations

- Never commit credentials or API keys
- Use `@n8n/permissions` for access control
- Validate all inputs using DTOs and schemas
- Encrypt sensitive data before database storage
- Follow OWASP guidelines for API security

## Performance Guidelines

- Use Turbo caching for builds
- Implement proper database indexing
- Use connection pooling for external APIs
- Monitor memory usage in long-running workflows
- Use partial executions for optimization

## Debugging

### VS Code Setup
Pre-configured launch configurations available in `.vscode/launch.json`:
- Debug main process
- Debug worker process
- Debug frontend with source maps

### Common Issues
- **Memory leaks**: Use `--max-old-space-size` flag for large workflows
- **Database locks**: Ensure proper transaction handling
- **Webhook timeouts**: Check `WEBHOOK_URL` configuration
- **TypeScript errors**: Run `pnpm typecheck` for detailed diagnostics

### Logging
- Use structured logging via Winston
- Log levels: error, warn, info, debug
- Avoid logging sensitive data (credentials, tokens)
- Use execution context for workflow-specific logs