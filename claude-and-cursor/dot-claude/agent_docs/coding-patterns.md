# TypeScript Coding Patterns

Read this before writing or modifying TypeScript code.

## Type System

**Interfaces vs Types**
- Interfaces for object shapes
- Type aliases for unions and primitives

```typescript
interface CustomerData {
    id: string;
    email: string;
    status: 'active' | 'inactive';
}

type UserId = string;
type Status = 'pending' | 'complete' | 'failed';
```

**Type Inference**
- Let TypeScript infer return types when obvious
- Explicit return types for public APIs or complex functions

```typescript
// Inferred: fine for internal functions
function getCustomer(id: string) {
    return database.findOne({ id });
}

// Explicit: public API
export function parseConfig(raw: string): Config {
    return JSON.parse(raw);
}
```

**Type Assertions**
- Use angle brackets: `<Type>value`
- Prefer type guards over assertions when possible

```typescript
const config = <ConfigType>JSON.parse(configJson);

// Better: type guard for runtime safety
function isConfig(value: unknown): value is ConfigType {
    return typeof value === 'object' && value !== null && 'setting' in value;
}
```

**Avoid `any`**
- Use `unknown` for truly unknown values
- Use type guards to narrow `unknown`

## Function Design

**Single Responsibility**
```typescript
// Bad: multiple concerns
async function processUserData(userData: UserData) {
    if (validateUser(userData)) {
        await saveToDatabase(userData);
        await sendWelcomeEmail(userData);
        await updateMetrics(userData);
    }
}

// Good: single concern
async function saveUser(userData: UserData) {
    if (!userData) throw new Error('User data required');
    return database.insert('users', userData);
}
```

**Early Returns**
```typescript
// Bad: nested
function processOrder(order) {
    if (order) {
        if (order.items?.length) {
            if (order.status === 'new') {
                return true;
            }
        }
    }
    return false;
}

// Good: guard clauses
function processOrder(order) {
    if (!order) return false;
    if (!order.items?.length) return false;
    if (order.status !== 'new') return false;
    return true;
}
```

**Parameters**
- Limit to 3 or fewer
- Use options object for more

## Functions Over Classes

```typescript
// Unnecessary class
class PriceCalculator {
    constructor(private taxRate: number) {}
    calculatePrice(basePrice: number) {
        return basePrice * (1 + this.taxRate);
    }
}

// Simple function
function calculatePrice(basePrice: number, taxRate: number) {
    return basePrice * (1 + taxRate);
}

// Closure if you need state
function createPriceCalculator(taxRate: number) {
    return (basePrice: number) => basePrice * (1 + taxRate);
}
```

## Import Style

```typescript
import assert from 'node:assert';
import * as mongodb from 'mongodb';
import { validateOrder } from '../lib/validation.js';
```

- ES modules only (never `require`)
- Prefer namespace imports for libraries: `import * as lib from 'lib'`
- Group: node builtins, external, internal
