---
title: React
description: React + TypeScript coding standards — folder structure, naming conventions, typing components and hooks, component architecture, props/state, performance (memo/useMemo/useCallback), testing, and common patterns.
---

## Table of Contents
- [General Principles](#general-principles)
- [File and Folder Structure](#file-and-folder-structure)
- [Naming Conventions](#naming-conventions)
- [TypeScript Usage](#typescript-usage)
- [Component Architecture](#component-architecture)
- [Props and State](#props-and-state)
- [Hooks](#hooks)
- [Styling](#styling)
- [Performance](#performance)
- [Testing](#testing)
- [Common Patterns](#common-patterns)

## General Principles

- **Component-based architecture**: Break your application into reusable, composable components
- **Single Responsibility**: Each component should do one thing well
- **DRY (Don't Repeat Yourself)**: Avoid code duplication
- **Immutability**: Treat state as immutable
- **Type Safety**: Leverage TypeScript for type checking

## File and Folder Structure

### Project Structure

```
src/
├── assets/              # Static assets (images, fonts, etc.)
├── components/          # Shared/reusable components
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.test.tsx
│   │   ├── Button.module.css (or .scss)
│   │   └── index.ts
│   └── ...
├── config/              # Configuration files
├── constants/           # Application constants
├── features/            # Feature-based modules
│   ├── auth/
│   │   ├── components/  # Feature-specific components
│   │   ├── hooks/       # Feature-specific hooks
│   │   ├── services/    # Feature-specific services
│   │   ├── types/       # Feature-specific types
│   │   └── index.ts     # Entry point for the feature
│   └── ...
├── hooks/               # Shared custom hooks
├── layouts/             # Layout components
├── pages/               # Page components
├── services/            # API services
├── store/               # State management
├── types/               # Shared TypeScript types and interfaces
├── utils/               # Utility functions
└── App.tsx              # Root component
```

### Component File Structure

Each component should have its own directory with the following files:

```
ComponentName/
├── ComponentName.tsx
├── ComponentName.test.tsx
├── ComponentName.module.css (or .scss)
└── index.ts
```

The `index.ts` file should export the component:

```typescript
export { default } from './ComponentName';
export * from './ComponentName';
```

## Naming Conventions

What | How | Good | Bad
------------ | ------------- | ------------- | -------------
Component file names | PascalCase | `Button.tsx` | ~~`button.tsx`~~
Component directories | Same as component name | `Button/` | ~~`button/`~~
Helper/utility files | camelCase | `dateUtils.ts` | ~~`DateUtils.ts`~~
Custom hooks | camelCase, start with "use" | `useAuth.ts` | ~~`auth.ts`~~
TypeScript interfaces | PascalCase, prefixed with "I" | `IUser` | ~~`user`~~
TypeScript types | PascalCase | `UserType` | ~~`userType`~~
TypeScript enums | PascalCase | `UserRole` | ~~`userRole`~~
Context files | PascalCase, end with "Context" | `AuthContext.tsx` | ~~`authContext.tsx`~~
CSS classes | camelCase or kebab-case | `buttonPrimary` or `button-primary` | ~~`ButtonPrimary`~~
Test files | Same as the file they test, with `.test` suffix | `Button.test.tsx` | ~~`ButtonTest.tsx`~~
Image files | kebab-case | `hero-image.png` | ~~`heroImage.png`~~

## TypeScript Usage

### Types vs Interfaces

- Use **types** by default for object shapes, including component props
- Use **interfaces** when you need to extend or implement them (inheritance)

```typescript
// Types for component props (preferred when no inheritance needed)
type ButtonProps = {
  text: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
};

// Type for union types
type Theme = 'light' | 'dark' | 'system';

// Interface when extending is needed
interface ExtendedButtonProps extends ButtonProps {
  icon?: React.ReactNode;
}
```

### Prop Types

Always define prop types for components using TypeScript:

```typescript
type UserCardProps = {
  user: {
    id: number;
    name: string;
    email: string;
  };
  isActive: boolean;
  onSelect: (id: number) => void;
};

function UserCard({ user, isActive, onSelect }: UserCardProps) {
  // Component implementation
}
```

### Typing Hooks

```typescript
// useState
const [user, setUser] = useState<User | null>(null);

// useRef
const inputRef = useRef<HTMLInputElement>(null);

// useContext
const theme = useContext<Theme>(ThemeContext);
```

### Type Assertions

Use type assertions sparingly and only when you know more about the type than TypeScript does:

```typescript
// Prefer
const input = document.getElementById('myInput') as HTMLInputElement;

// Over
const input = <HTMLInputElement>document.getElementById('myInput');
```

## Component Architecture

### Functional Components

Use function declarations for components instead of arrow functions with React.FC:

```typescript
import { useState, useEffect } from 'react';

type UserProfileProps = {
  userId: string;
};

function UserProfile({ userId }: UserProfileProps) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchUser = async () => {
      try {
        setLoading(true);
        const data = await userService.getUser(userId);
        setUser(data);
      } catch (error) {
        console.error('Failed to fetch user:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, [userId]);

  if (loading) return <Spinner />;
  if (!user) return <NotFound />;

  return (
    <div className="user-profile">
      <h1>{user.name}</h1>
      <p>{user.email}</p>
    </div>
  );
}

export default UserProfile;
```

### Component Composition

Prefer composition over inheritance to build reusable component systems:

```typescript
// Button component
type ButtonProps = {
  children: React.ReactNode;
  onClick?: () => void;
  disabled?: boolean;
};

function Button({ children, ...props }: ButtonProps) {
  return (
    <button className="button" {...props}>{children}</button>
  );
}

// Card component using composition
type CardProps = {
  title?: React.ReactNode;
  children: React.ReactNode;
  footer?: React.ReactNode;
};

function Card({ title, children, footer }: CardProps) {
  return (
    <div className="card">
      {title && <div className="card-header">{title}</div>}
      <div className="card-body">{children}</div>
      {footer && <div className="card-footer">{footer}</div>}
    </div>
  );
}

// Usage
type UserCardProps = {
  user: User;
  onEdit: (id: number) => void;
};

function UserCard({ user, onEdit }: UserCardProps) {
  return (
    <Card 
      title={user.name}
      footer={
        <Button onClick={() => onEdit(user.id)}>Edit</Button>
      }
    >
      <p>{user.bio}</p>
    </Card>
  );
}
```

## Props and State

### Props

1. **Destructure props** in function parameters:

```typescript
// Good
function Button({ onClick, children, disabled }: ButtonProps) {
  return (
    <button onClick={onClick} disabled={disabled}>{children}</button>
  );
}

// Avoid
function Button(props: ButtonProps) {
  return (
    <button onClick={props.onClick} disabled={props.disabled}>{props.children}</button>
  );
}
```

2. **Default props** should be defined using default parameters:

```typescript
function Button({ 
  variant = 'primary', 
  disabled = false,
  onClick,
  children 
}: ButtonProps) {
  // Component implementation
}
```

3. **Required vs Optional props**: Mark optional props with `?` in the type definition:

```typescript
type ButtonProps = {
  onClick: () => void;  // Required
  text: string;         // Required
  variant?: string;     // Optional
  disabled?: boolean;   // Optional
};
```

### State Management

1. **Local component state**: Use `useState` for component-specific state:

```typescript
const [count, setCount] = useState<number>(0);
```

2. **Complex local state**: Use `useReducer` for complex state logic:

```typescript
interface IState {
  count: number;
  isLoading: boolean;
}

type Action = 
  | { type: 'INCREMENT' }
  | { type: 'DECREMENT' }
  | { type: 'SET_LOADING'; payload: boolean };

const reducer = (state: IState, action: Action): IState => {
  switch (action.type) {
    case 'INCREMENT':
      return { ...state, count: state.count + 1 };
    case 'DECREMENT':
      return { ...state, count: state.count - 1 };
    case 'SET_LOADING':
      return { ...state, isLoading: action.payload };
    default:
      return state;
  }
};

// In component
const [state, dispatch] = useReducer(reducer, { count: 0, isLoading: false });
```

3. **Application state**: Use Context API for shared state across components:

```typescript
// Create context
export const ThemeContext = createContext<IThemeContext | undefined>(undefined);

// Context provider
type ThemeProviderProps = {
  children: React.ReactNode;
};

export function ThemeProvider({ children }: ThemeProviderProps) {
  const [theme, setTheme] = useState<Theme>('light');
  
  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };
  
  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// Custom hook for context
export const useTheme = () => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
};
```

4. **Global state management**: Use libraries like Redux or Jotai, or Zustand for global state management:
TBD

## Hooks

### Custom Hooks

Extract reusable logic into custom hooks:

```typescript
// Custom hook for form handling
function useForm<T extends object>(initialValues: T) {
  const [values, setValues] = useState<T>(initialValues);
  const [errors, setErrors] = useState<Partial<Record<keyof T, string>>>({});
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setValues(prev => ({ ...prev, [name]: value }));
  };
  
  const reset = () => {
    setValues(initialValues);
    setErrors({});
  };
  
  return { values, errors, handleChange, setErrors, reset };
}

// Usage
function SignupForm() {
  const { values, errors, handleChange, setErrors, reset } = useForm({
    email: '',
    password: ''
  });
  
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Validation and submission logic
  };
  
  return (
    <form onSubmit={handleSubmit}>
      <input
        name="email"
        value={values.email}
        onChange={handleChange}
      />
      {errors.email && <span>{errors.email}</span>}
      {/* Other fields */}
    </form>
  );
}
```

### Hook Rules

1. **Only call hooks at the top level** of your component or custom hooks
2. **Only call hooks from React functions** (components or custom hooks)
3. **Name custom hooks starting with "use"** to follow React's convention

## Styling
TBD

## Performance

### Memoization

1. **React.memo** for preventing unnecessary re-renders:

```typescript
type UserCardProps = {
  user: User;
  onSelect: (id: number) => void;
};

const UserCard = React.memo(function UserCard({ user, onSelect }: UserCardProps) {
  return (
    <div onClick={() => onSelect(user.id)}>
      <h3>{user.name}</h3>
      <p>{user.email}</p>
    </div>
  );
});
```

2. **useMemo** for expensive calculations:

```typescript
const sortedUsers = useMemo(() => {
  console.log('Sorting users'); // This should only run when users or sortField changes
  return [...users].sort((a, b) => a[sortField].localeCompare(b[sortField]));
}, [users, sortField]);
```

3. **useCallback** for memoized callbacks:

```typescript
const handleUserSelect = useCallback((userId: number) => {
  console.log('User selected:', userId);
  setSelectedUserId(userId);
}, []);
```

### Virtual Lists

For long lists, use virtualization libraries like `react-window` or `react-virtualized`:

```typescript
import { FixedSizeList } from 'react-window';

type UserListProps = {
  users: IUser[];
};

function UserList({ users }: UserListProps) {
  const Row = ({ index, style }: { index: number, style: React.CSSProperties }) => (
    <div style={style}>
      <span>{users[index].name}</span>
    </div>
  );

  return (
    <FixedSizeList
      height={500}
      width="100%"
      itemCount={users.length}
      itemSize={50}
    >
      {Row}
    </FixedSizeList>
  );
}
```

## Testing

### Component Tests

Use React Testing Library for component tests:

```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import Button from './Button';

describe('Button component', () => {
  test('renders with correct text', () => {
    render(<Button onClick={() => {}}>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  test('calls onClick handler when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    fireEvent.click(screen.getByText('Click me'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  test('is disabled when disabled prop is true', () => {
    render(<Button onClick={() => {}} disabled>Click me</Button>);
    expect(screen.getByText('Click me')).toBeDisabled();
  });
});
```

### Hook Tests

Test custom hooks with `renderHook` from `@testing-library/react`:

```typescript
import { renderHook, act } from '@testing-library/react';
import useCounter from './useCounter';

describe('useCounter', () => {
  test('should initialize with default value', () => {
    const { result } = renderHook(() => useCounter());
    expect(result.current.count).toBe(0);
  });

  test('should increment counter', () => {
    const { result } = renderHook(() => useCounter(5));
    
    act(() => {
      result.current.increment();
    });
    
    expect(result.current.count).toBe(6);
  });
});
```

## Common Patterns

### Conditional Rendering

```typescript
// Good - Short circuit evaluation for conditionals
{isLoggedIn && <UserProfile user={user} />}

// Good - Ternary for if/else scenarios
{isLoggedIn ? <UserProfile user={user} /> : <LoginForm />}

// Good - Extract complex conditions to variables or functions
const showAdminPanel = isLoggedIn && user.role === 'admin';
{showAdminPanel && <AdminPanel />}

// Avoid - Complex logic in JSX
{isLoggedIn && user.role === 'admin' && !isMaintenance && <AdminPanel />}
```

### Error Boundaries

Create error boundary components to catch and handle errors:

```typescript
import React, { ErrorInfo } from 'react';

interface IErrorBoundaryProps {
  fallback?: React.ReactNode;
  onError?: (error: Error, errorInfo: ErrorInfo) => void;
  children: React.ReactNode;
}

interface IErrorBoundaryState {
  hasError: boolean;
  error?: Error;
}

class ErrorBoundary extends React.Component<IErrorBoundaryProps, IErrorBoundaryState> {
  constructor(props: IErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error): IErrorBoundaryState {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo): void {
    this.props.onError?.(error, errorInfo);
  }

  render(): React.ReactNode {
    if (this.state.hasError) {
      return this.props.fallback || <div>Something went wrong</div>;
    }

    return this.props.children;
  }
}

// Usage
<ErrorBoundary 
  fallback={<ErrorPage />}
  onError={(error, info) => logErrorToService(error, info)}
>
  <MyComponent />
</ErrorBoundary>
```

### Render Props

Type render props correctly:

```typescript
type WithMouseProps = {
  render: (mouse: { x: number; y: number }) => React.ReactNode;
};

function WithMouse({ render }: WithMouseProps) {
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
  
  const handleMouseMove = (e: React.MouseEvent) => {
    setMousePosition({ x: e.clientX, y: e.clientY });
  };
  
  return (
    <div onMouseMove={handleMouseMove}>
      {render(mousePosition)}
    </div>
  );
}

// Usage
<WithMouse
  render={({ x, y }) => (
    <div>Mouse position: {x}, {y}</div>
  )}
/>
```

### Higher-Order Components (HOCs)

Type HOCs correctly:

```typescript
type WithAuthProps = {
  isAuthenticated: boolean;
  user: User | null;
};

function withAuth<P extends WithAuthProps>(
  Component: React.ComponentType<P>
): React.FC<Omit<P, keyof WithAuthProps>> {
  return (props) => {
    const { isAuthenticated, user } = useAuth();
    
    if (!isAuthenticated) {
      return <Redirect to="/login" />;
    }
    
    return <Component {...(props as P)} isAuthenticated={isAuthenticated} user={user} />;
  };
}

// Usage
type ProfilePageProps = WithAuthProps & {
  // Additional props
};

function ProfilePage({ user }: ProfilePageProps) {
  return <div>Hello, {user?.name}</div>;
}

const AuthenticatedProfilePage = withAuth(ProfilePage);
```