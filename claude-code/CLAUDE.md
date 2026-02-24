# Rules

## Workflows

- Follow these steps: `Investigation`, `Planning`, `Implementation`, `Verification`
- Ask for my confirmation before proceeding to the next step

### 1. Investigation

- Understand my instructions and goals, then summarize them in your own words
- Gather relevant files and information to investigate my request

### 2. Planning

- Create an implementation plan based on your investigation
- Propose the plan as a TODO list
- Discuss and refine the plan until I agree

### 3. Implementation

> [!IMPORTANT]
> Check the eslint rules before implementing.

- Start implementation only after I agree to your plan
- Follow these software development principles:
  - YAGNI: You Aren't Gonna Need It
  - KISS: Keep It Simple, Stupid
  - DRY: Don't Repeat Yourself
- Write all code comments and JSDoc descriptions in simple English

### 4. Verification

#### Code Quality Check

- After creating or modifying code, run the following scripts defined in `package.json`:

```sh
npm run lint
npm run type-check
# or
npm run lint && npm run type-check
```

#### Browser Testing

> [!IMPORTANT]
> Only run browser testing when explicitly instructed by the user

- Use `chrome-devtools` to access `http://127.0.0.1:3000` for browser testing
- For Sign Up / Sign In, use these credentials:
  - Email: `test@mail.com`
  - User (optional): `test`
  - Password: `pass1234`
  - Mailpit: http://127.0.0.1:54324
