# Code Quality Standards

This file provides code quality examples and patterns for the builder agent.

## TypeScript/JavaScript Examples

### Good Patterns ✅

**Interfaces and Type Safety:**
```typescript
interface UserProfile {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
}

function getUserProfile(userId: string): Promise<UserProfile> {
  if (!userId) {
    throw new Error('User ID is required');
  }
  return api.get<UserProfile>(`/users/${userId}`);
}
```

**Async/Await Error Handling:**
```typescript
async function fetchUserData(userId: string): Promise<UserData> {
  try {
    const response = await api.get(`/users/${userId}`);
    return response.data;
  } catch (error) {
    if (error.response?.status === 404) {
      throw new Error(`User ${userId} not found`);
    }
    throw new Error(`Failed to fetch user: ${error.message}`);
  }
}
```

**DRY Principle:**
```typescript
// Extract common validation logic
function validateRequired(value: string, fieldName: string): void {
  if (!value || value.trim() === '') {
    throw new ValidationError(`${fieldName} is required`);
  }
}

function createUser(data: UserInput): User {
  validateRequired(data.name, 'Name');
  validateRequired(data.email, 'Email');
  // ... rest of logic
}
```

### Bad Patterns ❌

**Avoid:**
```typescript
// No type safety
function get(id: any) {
  return api.get('/users/' + id);
}

// Poor error handling
async function getData() {
  const data = await api.get('/data'); // no try-catch
  return data;
}

// Not DRY
function validateUser(user) {
  if (!user.name || user.name.trim() === '') {
    throw new Error('Name is required');
  }
  if (!user.email || user.email.trim() === '') {
    throw new Error('Email is required');
  }
}
```

## Testing Standards

### Good Test Structure ✅

```typescript
describe('getUserProfile', () => {
  it('should fetch user profile with valid ID', async () => {
    const userId = 'user-123';
    const result = await getUserProfile(userId);

    expect(result).toHaveProperty('id', userId);
    expect(result).toHaveProperty('name');
    expect(result).toHaveProperty('email');
  });

  it('should throw error when userId is empty', async () => {
    await expect(getUserProfile('')).rejects.toThrow('User ID is required');
  });

  it('should handle API errors gracefully', async () => {
    mockApi.get.mockRejectedValue(new Error('Network error'));

    await expect(getUserProfile('user-123')).rejects.toThrow('Failed to fetch user');
  });
});
```

### Test Organization

```typescript
describe('UserService', () => {
  // Setup
  beforeEach(() => {
    // Initialize test state
  });

  // Teardown
  afterEach(() => {
    // Clean up
  });

  // Group related tests
  describe('getUserProfile', () => {
    it('should handle valid input', async () => { /* ... */ });
    it('should handle invalid input', async () => { /* ... */ });
  });

  describe('updateUser', () => {
    it('should update user data', async () => { /* ... */ });
    it('should validate required fields', async () => { /* ... */ });
  });
});
```

## React/Next.js Patterns

### Component Structure ✅

```typescript
interface ButtonProps {
  label: string;
  onClick: () => void;
  disabled?: boolean;
  variant?: 'primary' | 'secondary';
}

export function Button({
  label,
  onClick,
  disabled = false,
  variant = 'primary'
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
      aria-label={label}
    >
      {label}
    </button>
  );
}
```

### Hooks Best Practices ✅

```typescript
// Custom hook with proper dependency array
function useUserData(userId: string) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    let cancelled = false;

    async function fetchUser() {
      try {
        setLoading(true);
        const data = await getUserProfile(userId);
        if (!cancelled) {
          setUser(data);
        }
      } catch (err) {
        if (!cancelled) {
          setError(err as Error);
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    }

    fetchUser();

    return () => {
      cancelled = true;
    };
  }, [userId]);

  return { user, loading, error };
}
```

## Clean Code Checklist

- [ ] **Readable names**: Variables, functions, classes are self-documenting
- [ ] **Small functions**: One responsibility per function (< 50 lines)
- [ ] **DRY**: Common logic extracted, no duplication
- [ ] **KISS**: Simplest solution that works
- [ ] **Error handling**: Proper try-catch, meaningful error messages
- [ ] **Comments**: Explain WHY, not WHAT (code explains what)
- [ ] **Type safety**: Use TypeScript types/interfaces
- [ ] **Immutability**: Prefer const, avoid mutations where possible
- [ ] **Pure functions**: Predictable output for given input
- [ ] **Async/await**: Consistent async pattern, proper error handling
