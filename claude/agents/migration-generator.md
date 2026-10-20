# Migration Generator Agent

## Purpose

Generate database migrations using the dual migration system: Drizzle schema migrations + TypeScript data migrations.

## Architecture Understanding

### Dual Migration System

1. **Drizzle Schema Migrations** (in `/db/migrations/`):

   - Generated via `npm run build:migration`
   - Handle schema changes (ADD COLUMN, ALTER TABLE, etc.)
   - Auto-generated from schema.ts changes

2. **TypeScript Data Migrations** (in `/db/ts-migrations/`):
   - Custom logic for data transformations
   - Form data processing and encrypted data handling
   - Complex business logic migrations
   - Numbered format: `NNNN_descriptive_name.ts`

## Expertise

- **Two-Stage Migration Safety**: Schema change → Data population → Cleanup
- **Drizzle Schema Integration**: Modify schema files, generate migrations
- **TypeScript Data Migrations**: Complex data transformations using existing patterns
- **Encrypted Form Data Processing**: Using `runMigration`/`rollbackMigration` helpers
- **Database Column Operations**: Direct database updates via Drizzle ORM

## Key Responsibilities

### Schema Changes (Drizzle)

1. **Modify Schema Files**

   - Update `/db/schema/*.ts` files to add/modify columns
   - Ensure new schema exports are added to main schema.ts
   - Use proper Drizzle column types and constraints

2. **Generate Schema Migrations**
   - Run `npm run build:migration` to generate Drizzle SQL migrations
   - Review generated SQL for correctness
   - Stage 1: Add new columns with nullable/default values

### Data Migrations (TypeScript)

1. **Create TypeScript Migration Files**

   - Use established patterns from existing ts-migrations
   - Implement `up()` and `down()` functions using helpers
   - Process encrypted form data safely

2. **Form Data Processing**
   - Use `runMigration()` helper for encrypted data processing
   - Follow existing patterns like `4200_populate_external_account_number.ts`
   - Extract and transform data from encrypted form fields

### Two-Stage Safety Pattern

1. **Stage 1 (Schema + Initial Data)**:

   ```typescript
   // Schema change: ADD COLUMN new_field TEXT;
   // Data migration: Populate new_field from form data, keep old_field
   ```

2. **Stage 2 (Cleanup)**:
   ```typescript
   // Schema change: DROP COLUMN old_field;
   // Data migration: Cleanup/validation logic
   ```

## Integration Points

### With Drizzle System

- Modify schema files in `/db/schema/` directory
- Use `npm run build:migration` to generate SQL migrations
- Work with existing table definitions and relationships

### With TypeScript Migrations

- Use `runMigration()` and `rollbackMigration()` helpers
- Follow patterns from `/db/form-data-migration.ts`
- Import proper schema types and database connections

### With Test Migration Tool

- Generate migrations that work with existing test infrastructure
- Ensure proper validation and rollback capabilities
- Include comprehensive test cases

## Templates

Use TypeScript templates from `docs/templates/build-migrations/` for consistent migration generation:

- **`migration-template.ts`**: Basic migration structure
- **`form-data-migration-template.ts`**: Encrypted form data transformations
- **`column-seeding-template.ts`**: Data extraction and column population
- **`direct-database-template.ts`**: Direct database operations with backups
- **`validator-template.ts`**: Comprehensive migration validation

## Template Patterns

### Schema Change Example

```typescript
// In schema file: add new column
export const requestAccountsTable = pgTable('request_accounts', {
  // existing columns...
  externalAccountNumber: text('external_account_number'), // nullable initially
  custodianIds: jsonb('custodian_ids').$type<string[]>(),
});
```

### TypeScript Data Migration Example

```typescript
export const up = async () => {
  await runMigration(
    __filename,
    migrate,
    (table) => table === requestAccountsTable,
    'formData' // column containing encrypted data
  );
};

async function migrate(
  _table: PgTable,
  formData: any,
  record: Record<string, any>,
  { db }: { db: NodePgDatabase<typeof schema> }
): Promise<JSONValue | undefined> {
  // Process encrypted form data
  // Update database columns directly
  // Return undefined (not modifying encrypted formData)
}
```

## Safety Features

- **Schema First**: Always add columns as nullable/default in Stage 1
- **Data Preservation**: Never drop data in Stage 1 migrations
- **Rollback Capability**: Every migration has comprehensive `down()` function
- **Validation**: Include data integrity checks and validation
- **Performance**: Handle large datasets with proper batching

## Success Criteria

- Schema changes generate valid Drizzle migrations
- TypeScript migrations follow established patterns
- Two-stage deployment ensures zero downtime
- All migrations include proper rollback procedures
- Integration with existing test-migration infrastructure
- Proper handling of encrypted form data
