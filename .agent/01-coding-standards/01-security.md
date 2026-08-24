---
title: Security
description: Secure backend coding standards for PHP, Laravel, Node.js, and Go — common vulnerabilities (SQLi, XSS, CSRF, SSRF, mass assignment, JWT, timing attacks) with bad/good examples and mitigations, graded by severity.
---

## General Information

**Scope:** Backend web, API, server-side code (PHP, Laravel, NodeJS, Go)

### **Purpose**

Standard document for code review, training, and security quality assessment in backend development. Helps developers avoid common security vulnerabilities and improve code quality.

### **Security Levels**

| Level | Icon | Examples |
|-------|------|----------|
| **Critical** | 🔴 | RCE, SQLi, Auth Bypass, Hardcoded Secrets |
| **High** | 🟡 | XSS, CSRF, SSRF, Data Exposure |
| **Medium** | 🟠 | Misconfigurations, Weak Crypto |
| **Low** | 🟢 | Info Disclosure, Best Practices |

---

## Table of contents

<!--ts-->
- [Kozocom Coding Guidelines - Security](#kozocom-coding-guidelines---security)
  - [General Information](#general-information)
    - [**Purpose**](#purpose)
    - [**Security Levels**](#security-levels)
  - [Table of contents](#table-of-contents)
  - [Common Security Vulnerabilities](#common-security-vulnerabilities)
    - [**SQL Injection** 🔴 Critical](#sql-injection--critical)
    - [**Cross-Site Scripting (XSS)** 🟡 High](#cross-site-scripting-xss--high)
    - [**Cross-Site Request Forgery (CSRF)** 🟡 High](#cross-site-request-forgery-csrf--high)
    - [**Hardcoded Secrets** 🔴 Critical](#hardcoded-secrets--critical)
    - [**Insecure Authentication** 🟡 High](#insecure-authentication--high)
    - [**Broken Access Control** 🟡 High](#broken-access-control--high)
    - [**Sensitive Data Exposure** 🟠 Medium](#sensitive-data-exposure--medium)
    - [**Server-Side Request Forgery (SSRF)** 🟠 Medium](#server-side-request-forgery-ssrf--medium)
    - [**Insecure File Upload** 🟠 Medium](#insecure-file-upload--medium)
    - [**Security Misconfiguration** 🟠 Medium](#security-misconfiguration--medium)
    - [**Command Injection** 🔴 Critical](#command-injection--critical)
    - [**Insecure Deserialization** 🟡 High](#insecure-deserialization--high)
    - [**Laravel Mass Assignment** 🟡 High](#laravel-mass-assignment--high)
    - [**Laravel Query Injection** 🔴 Critical](#laravel-query-injection--critical)
    - [**NodeJS Prototype Pollution** 🟡 High](#nodejs-prototype-pollution--high)
    - [**NodeJS Path Traversal** 🟠 Medium](#nodejs-path-traversal--medium)
    - [**Go Race Conditions** 🟠 Medium](#go-race-conditions--medium)
    - [**Go Memory Exhaustion** 🟠 Medium](#go-memory-exhaustion--medium)
    - [**JWT Security Issues** 🟡 High](#jwt-security-issues--high)
    - [**GraphQL Security** 🟠 Medium](#graphql-security--medium)
    - [**API Rate Limiting** 🟠 Medium](#api-rate-limiting--medium)
    - [**Timing Attacks** 🟠 Medium](#timing-attacks--medium)
<!--te-->

---

<a name="common-security-vulnerabilities"></a>
## Common Security Vulnerabilities

<a name="sql-injection"></a>
### **SQL Injection** 🔴 Critical

**Description:** Attackers can execute arbitrary SQL commands through unvalidated input.

**Bad:**
```php
$query = "SELECT * FROM users WHERE id = " . $_GET['id'];
$result = mysqli_query($connection, $query);
```

**Good:**
```php
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$_GET['id']]);
$result = $stmt->fetchAll();
```

**Mitigation:** Use prepared statements, parameterized queries, ORM instead of string concatenation.

---

<a name="cross-site-scripting-xss"></a>
### **Cross-Site Scripting (XSS)** 🟡 High

**Description:** Attackers inject malicious scripts into web pages, potentially stealing cookies or session tokens.

**Bad:**
```php
echo "Hello " . $_POST['username'];
```

**Good:**
```php
echo "Hello " . htmlspecialchars($_POST['username'], ENT_QUOTES, 'UTF-8');
```

**Mitigation:** HTML encode all user input, use Content Security Policy (CSP).

---

<a name="cross-site-request-forgery-csrf"></a>
### **Cross-Site Request Forgery (CSRF)** 🟡 High

**Description:** Tricks users into performing unauthorized actions on websites they're authenticated to.

**Bad:**
```php
if ($_POST['action'] === 'delete_account') {
  deleteAccount($_SESSION['user_id']);
}
```

**Good:**
```php
Route::post('/delete-account', 'AccountController@delete')->middleware('web');

// Or manual check (use hash_equals for constant-time comparison)
if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
  die('CSRF token mismatch');
}
```

**Mitigation:** Use CSRF tokens, SameSite cookies, verify Origin header.

---

<a name="hardcoded-secrets"></a>
### **Hardcoded Secrets** 🔴 Critical

**Description:** API keys, passwords, tokens hardcoded in source code.

**Bad:**
```php
$apiKey = 'sk-1234567890abcdef';
$dbPassword = 'mySecretPassword123';
```

**Good:**
```php
$apiKey = $_ENV['API_KEY'];
$dbPassword = $_ENV['DB_PASSWORD'];

// Or Laravel
$apiKey = config('services.openai.key');
```

**Mitigation:** Use environment variables, AWS Secrets Manager, HashiCorp Vault.

---

<a name="insecure-authentication"></a>
### **Insecure Authentication** 🟡 High

**Description:** Weak password policies, insecure session management, missing MFA.

**Bad:**
```php
if ($_POST['password'] === $storedPassword) {
  $_SESSION['user_id'] = $user['id'];
  session_start();
}
```

**Good:**
```php
if (password_verify($_POST['password'], $storedHash)) {
  session_regenerate_id(true);
  $_SESSION['user_id'] = $user['id'];
  $_SESSION['last_activity'] = time();
}
```

**Mitigation:** Bcrypt/Argon2 hashing, secure session config, account lockout, MFA.

---

<a name="broken-access-control"></a>
### **Broken Access Control** 🟡 High

**Description:** Users can access resources they don't have permission to.

**Bad:**
```php
function getUser($userId) {
  return User::find($userId); // No ownership check
}
```

**Good:**
```php
function getUser($userId) {
  $currentUser = auth()->user();
    
  if ($currentUser->id !== $userId && !$currentUser->isAdmin()) {
    abort(403, 'Forbidden');
  }
    
  return User::find($userId);
}
```

**Mitigation:** Implement proper authorization checks, principle of least privilege, RBAC.

---

<a name="sensitive-data-exposure"></a>
### **Sensitive Data Exposure** 🟠 Medium

**Description:** PII, passwords, financial data not properly protected.

**Bad:**
```php
error_log("Login failed for: " . $password);
return response()->json(['user' => $user]); // Includes password hash
```

**Good:**
```php
error_log("Login failed for user ID: " . $user->id);
return response()->json(['user' => $user->only(['id', 'name', 'email'])]);
```

**Mitigation:** Encrypt sensitive data, selective serialization, safe logging practices.

---

<a name="server-side-request-forgery-ssrf"></a>
### **Server-Side Request Forgery (SSRF)** 🟠 Medium

**Description:** Attackers can make the server send requests to internal services.

**Bad:**
```php
$url = $_POST['callback_url'];
$response = file_get_contents($url); // Can access internal services
```

**Good:**
```php
$url = $_POST['callback_url'];
$parsed = parse_url($url);

$allowedHosts = ['api.example.com', 'webhook.partner.com'];
if (!in_array($parsed['host'], $allowedHosts)) {
  throw new Exception('Host not allowed');
}

$response = file_get_contents($url);
```

**Mitigation:** Whitelist allowed hosts, validate URLs, use separate network for external requests.

---

<a name="insecure-file-upload"></a>
### **Insecure File Upload** 🟠 Medium

**Description:** Uploaded files may contain malware or executable code.

**Bad:**
```php
move_uploaded_file($_FILES['file']['tmp_name'], 'uploads/' . $_FILES['file']['name']);
```

**Good:**
```php
$allowedTypes = ['jpg', 'png', 'pdf'];
$fileExtension = pathinfo($_FILES['file']['name'], PATHINFO_EXTENSION);

if (!in_array(strtolower($fileExtension), $allowedTypes)) {
  throw new Exception('File type not allowed');
}

$fileName = uniqid() . '.' . $fileExtension;
move_uploaded_file($_FILES['file']['tmp_name'], 'uploads/' . $fileName);
```

**Mitigation:** File type validation, rename files, store outside web root, virus scanning.

---

<a name="security-misconfiguration"></a>
### **Security Misconfiguration** 🟠 Medium

**Description:** Default passwords, debug mode enabled, missing security headers.

**Bad:**
```php
// .env
APP_DEBUG=true
DB_PASSWORD=password

// No security headers
```

**Good:**
```php
// .env
APP_DEBUG=false
DB_PASSWORD=complex_random_password

// Security headers
header('X-Frame-Options: DENY');
header('X-Content-Type-Options: nosniff');
header('Strict-Transport-Security: max-age=31536000');
```

**Mitigation:** Disable debug in production, strong passwords, security headers, regular updates.

---

<a name="command-injection"></a>
### **Command Injection** 🔴 Critical

**Description:** Attackers can execute OS commands through user input.

**Bad:**
```php
$filename = $_POST['filename'];
exec("convert $filename output.pdf");
```

**Good:**
```php
$filename = $_POST['filename'];
$safeFilename = escapeshellarg($filename);
exec("convert $safeFilename output.pdf");

// Better: use libraries instead of system commands
```

**Mitigation:** Escape shell arguments, use libraries instead of system calls, input validation.

---

<a name="insecure-deserialization"></a>
### **Insecure Deserialization** 🟡 High

**Description:** Deserializing untrusted data can lead to remote code execution.

**Bad:**
```php
$data = unserialize($_POST['data']);
```

**Good:**
```php
$data = json_decode($_POST['data'], true);

// Or if you need to serialize objects
$data = unserialize($_POST['data'], ['allowed_classes' => ['SafeClass']]);
```

**Mitigation:** Use JSON instead of serialize, whitelist allowed classes, input validation.

---

<a name="laravel-mass-assignment"></a>
### **Laravel Mass Assignment** 🟡 High

**Description:** Attackers can modify unintended model attributes through mass assignment.

**Bad:**
```php
// User model without $fillable or $guarded
class User extends Model
{
    // No protection
}

// Controller
public function update(Request $request, User $user)
{
    $user->update($request->all()); // Can update is_admin, role, etc.
}
```

**Good:**
```php
class User extends Model
{
    protected $fillable = ['name', 'email'];
    // Or
    protected $guarded = ['id', 'is_admin', 'role', 'created_at', 'updated_at'];
}

// Controller with validation
public function update(UpdateUserRequest $request, User $user)
{
    $validated = $request->validated();
    $user->update($validated);
}
```

**Mitigation:** Use $fillable/$guarded, form request validation, explicit attribute assignment.

---

<a name="laravel-query-injection"></a>
### **Laravel Query Injection** 🔴 Critical

**Description:** SQL injection through Eloquent ORM when using raw queries or dynamic methods.

**Bad:**
```php
// Non-parameterized raw queries
DB::select("SELECT * FROM users WHERE name = '{$request->name}'");

// Dynamic where clauses
$column = $request->input('sort');
User::orderBy($column, 'desc')->get(); // $column could be "(SELECT SLEEP(10))"
```

**Good:**
```php
// Parameterized queries
DB::select("SELECT * FROM users WHERE name = ?", [$request->name]);

// Whitelist columns
$allowedColumns = ['name', 'email', 'created_at'];
$column = in_array($request->sort, $allowedColumns) ? $request->sort : 'created_at';
User::orderBy($column, 'desc')->get();
```

**Mitigation:** Parameterized queries, whitelist dynamic inputs, use Eloquent query builder safely.

---

<a name="nodejs-prototype-pollution"></a>
### **NodeJS Prototype Pollution** 🟡 High

**Description:** Attackers can modify Object.prototype, affecting the entire application.

**Bad:**
```javascript
function merge(target, source) {
    for (let key in source) {
        target[key] = source[key]; // Can pollute __proto__
    }
    return target;
}

// Attack payload: {"__proto__": {"isAdmin": true}}
```

**Good:**
```javascript
function merge(target, source) {
    for (let key in source) {
        if (key === '__proto__' || key === 'constructor' || key === 'prototype') {
            continue;
        }
        target[key] = source[key];
    }
    return target;
}

// Or use Map instead of Object
const config = new Map();
```

**Mitigation:** Validate object keys, use Map instead of Object, freeze prototypes, use safe merge libraries.

---

<a name="nodejs-path-traversal"></a>
### **NodeJS Path Traversal** 🟠 Medium

**Description:** Attackers can access files outside the intended directory through path manipulation.

**Bad:**
```javascript
const express = require('express');
const path = require('path');
const fs = require('fs');

app.get('/files/:filename', (req, res) => {
    const filename = req.params.filename;
    const filePath = path.join(__dirname, 'uploads', filename);
    res.sendFile(filePath); // Vulnerable to ../../../etc/passwd
});
```

**Good:**
```javascript
app.get('/files/:filename', (req, res) => {
    const filename = req.params.filename;
    
    // Validate filename
    if (filename.includes('..') || filename.includes('/') || filename.includes('\\')) {
        return res.status(400).send('Invalid filename');
    }
    
    const filePath = path.join(__dirname, 'uploads', filename);
    
    // Ensure resolved path is within uploads directory
    const uploadDir = path.resolve(__dirname, 'uploads');
    const resolvedPath = path.resolve(filePath);
    
    if (!resolvedPath.startsWith(uploadDir)) {
        return res.status(403).send('Access denied');
    }
    
    res.sendFile(resolvedPath);
});
```

**Mitigation:** Validate file paths, use path.resolve() checks, sanitize user input, whitelist file extensions.

---

<a name="go-race-conditions"></a>
### **Go Race Conditions** 🟠 Medium

**Description:** Concurrent access to shared resources without proper synchronization can lead to data corruption.

**Bad:**
```go
type Counter struct {
    value int
}

func (c *Counter) Increment() {
    c.value++ // Race condition when multiple goroutines access
}

func main() {
    counter := &Counter{}
    for i := 0; i < 100; i++ {
        go counter.Increment()
    }
}
```

**Good:**
```go
import "sync"

type Counter struct {
    mu    sync.Mutex
    value int
}

func (c *Counter) Increment() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.value++
}

// Or use atomic operations
import "sync/atomic"

type AtomicCounter struct {
    value int64
}

func (c *AtomicCounter) Increment() {
    atomic.AddInt64(&c.value, 1)
}
```

**Mitigation:** Use mutexes, atomic operations, channels for communication, avoid shared mutable state.

---

<a name="go-memory-exhaustion"></a>
### **Go Memory Exhaustion** 🟠 Medium

**Description:** Unbounded resource consumption can lead to DoS attacks.

**Bad:**
```go
func handleRequest(w http.ResponseWriter, r *http.Request) {
    // Read entire request body without limits
    body, err := io.ReadAll(r.Body)
    if err != nil {
        http.Error(w, "Error reading body", 500)
        return
    }
    
    // Process unlimited data
    processData(body)
}
```

**Good:**
```go
func handleRequest(w http.ResponseWriter, r *http.Request) {
    // Limit request body size
    maxBytes := int64(1024 * 1024) // 1MB limit
    r.Body = http.MaxBytesReader(w, r.Body, maxBytes)
    
    body, err := io.ReadAll(r.Body)
    if err != nil {
        http.Error(w, "Request too large", 413)
        return
    }
    
    processData(body)
}

// Or use context with timeout
func handleWithTimeout(w http.ResponseWriter, r *http.Request) {
    ctx, cancel := context.WithTimeout(r.Context(), 30*time.Second)
    defer cancel()
    
    // Process with timeout
    processDataWithContext(ctx, data)
}
```

**Mitigation:** Set request size limits, use timeouts, implement rate limiting, monitor resource usage.

---

<a name="jwt-security-issues"></a>
### **JWT Security Issues** 🟡 High

**Description:** Weak JWT implementation can lead to authentication bypass.

**Bad:**
```php
// Laravel - Weak secret key
'key' => 'secret',

// NodeJS - Algorithm confusion
jwt.verify(token, publicKey, { algorithms: ['HS256', 'RS256'] });

// Go - No expiration check
claims := jwt.MapClaims{}
jwt.ParseWithClaims(tokenString, claims, keyFunc)
```

**Good:**
```php
// Laravel - Strong secret
'key' => env('JWT_SECRET', Str::random(64)),

// NodeJS - Explicit algorithm
jwt.verify(token, publicKey, { 
    algorithms: ['RS256'],
    maxAge: '1h'
});

// Go - Proper validation
claims := &jwt.StandardClaims{}
token, err := jwt.ParseWithClaims(tokenString, claims, keyFunc)
if err != nil || !token.Valid {
    return errors.New("invalid token")
}
if time.Now().Unix() > claims.ExpiresAt {
    return errors.New("token expired")
}
```

**Mitigation:** Strong secrets, explicit algorithms, proper expiration, validate all claims.

---

<a name="graphql-security"></a>
### **GraphQL Security** 🟠 Medium

**Description:** GraphQL queries can be abused to cause DoS or data exposure.

**Bad:**
```javascript
// Unlimited depth/complexity
const typeDefs = `
  type User {
    id: ID!
    friends: [User]
  }
`;

// No rate limiting for queries
```

**Good:**
```javascript
const depthLimit = require('graphql-depth-limit');
const costAnalysis = require('graphql-query-complexity');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [
    depthLimit(10),
    costAnalysis({
      maximumCost: 1000,
      variables: {},
      createError: (max, actual) => {
        return new Error(`Query cost ${actual} exceeds maximum cost ${max}`);
      }
    })
  ]
});
```

**Mitigation:** Query depth limiting, complexity analysis, rate limiting, disable introspection in production.

---

<a name="api-rate-limiting"></a>
### **API Rate Limiting** 🟠 Medium

**Description:** Lack of rate limiting can lead to DoS attacks and resource exhaustion.

**Bad:**
```php
// Laravel - No rate limiting
Route::post('/api/login', 'AuthController@login');

// NodeJS - Unlimited requests
app.post('/api/upload', uploadHandler);
```

**Good:**
```php
// Laravel - Built-in rate limiting
Route::post('/api/login', 'AuthController@login')
    ->middleware('throttle:5,1'); // 5 attempts per minute

// Custom rate limiting
Route::middleware('throttle:api')->group(function () {
    Route::apiResource('users', 'UserController');
});
```

```javascript
// NodeJS - Express rate limiting
const rateLimit = require('express-rate-limit');

const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP'
});

app.use('/api/', apiLimiter);
```

**Mitigation:** Implement rate limiting, different limits for different endpoints, use distributed rate limiting for scale.

---

<a name="timing-attacks"></a>
### **Timing Attacks** 🟠 Medium

**Description:** Response time differences can leak information about system state.

**Bad:**
```php
// Password comparison
if ($_POST['password'] === $storedPassword) {
    return 'success';
}

// User enumeration
$user = User::where('email', $email)->first();
if (!$user) {
    return 'User not found'; // Fast response
}
if (!password_verify($password, $user->password)) {
    return 'Invalid password'; // Slower response
}
```

**Good:**
```php
// Constant-time comparison
if (hash_equals($storedPassword, $_POST['password'])) {
    return 'success';
}

// Consistent timing
$user = User::where('email', $email)->first();
$validUser = !is_null($user);
$validPassword = $validUser && password_verify($password, $user->password);

// Always hash to maintain consistent timing
if (!$validUser) {
    password_verify($password, '$2y$10$dummy.hash.to.maintain.timing');
}

if ($validUser && $validPassword) {
    return 'success';
} else {
    return 'Invalid credentials';
}
```

**Mitigation:** Use constant-time comparisons, consistent response times, avoid early returns based on sensitive data.

---

**Last Updated:** October 2025 | **Version:** 1.0.0