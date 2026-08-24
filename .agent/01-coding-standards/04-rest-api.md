---
title: REST API
description: RESTful API design standards — resource naming, HTTP methods, URL structure, request/response format, status codes, versioning, error handling, documentation, performance (pagination, filtering, caching, rate limiting), and testing.
---

## Table of Contents
- [General Principles](#general-principles)
- [Resource Naming](#resource-naming)
- [HTTP Methods](#http-methods)
- [URL Structure](#url-structure)
- [Request/Response Format](#requestresponse-format)
- [Status Codes](#status-codes)
- [Versioning](#versioning)
- [Error Handling](#error-handling)
- [Authentication and Authorization](#authentication-and-authorization)
- [Documentation](#documentation)
- [Performance Considerations](#performance-considerations)
- [Testing](#testing)

## Resource Naming
1. **Use nouns, not verbs**: Resources should be named with nouns, not verbs.
   - Good: `/users`, `/articles`
   - Avoid: `/getUsers`, `/createArticle`

2. **Use plural nouns** for collection resources:
   - Good: `/users`, `/articles`
   - Avoid: `/user`, `/article`

3. **Use kebab-case** for multi-word resource names:
   - Good: `/user-profiles`, `/blog-posts`
   - Avoid: `/userProfiles`, `/blogPosts`, `/user_profiles`

4. **Keep resource names lowercase**:
   - Good: `/users`
   - Avoid: `/Users

## HTTP Methods
Use HTTP methods according to their defined semantics:

1. **GET**: Retrieve resources (read-only)
   - Must be safe and idempotent
   - Never use for operations that change state

2. **POST**: Create new resources
   - Use for non-idempotent operations
   - Use for complex operations that can't map to other HTTP methods

3. **PUT**: Update resources by replacing the entire resource
   - Must be idempotent
   - Requires the full resource representation

4. **PATCH**: Partial updates to resources
   - Apply partial modifications to a resource
   - Use JSON Patch or JSON Merge Patch format

5. **DELETE**: Remove resources
   - Must be idempotent
   - Return 204 No Content on success if no response body is returned

## URL Structure

1. **Resource hierarchy**:
   - Express relationships using nested resources
   - Example: `/users/{userId}/orders/{orderId}`
   - Limit nesting to maximum 2-3 levels

2. **Query parameters**:
   - Use for filtering, sorting, pagination, and field selection
   - Examples: 
     - `/users?role=admin`
     - `/articles?sort=created_at&order=desc`
     - `/products?page=2&per_page=25`

## Request/Response Format
1. **JSON format**:
   - Use JSON as the default format for request/response bodies
   - Set `Content-Type: application/json` header
   - Use camelCase for property names(snake_case for Laravel)
   ```json
   {
     "firstName": "John",
     "lastName": "Doe"
   }
   ```

2. **Response structure**:
   - Keep a consistent structure across all endpoints
   - Include metadata when appropriate
   ```json
   {
     "data": { ... },
     "metadata": {
       "totalCount": 100,
       "page": 2,
       "perPage": 25
     }
   }
   ```

3. **Date and time formats**:
   - Use ISO 8601 format (UTC): `YYYY-MM-DDTHH:MM:SSZ`
   - Example: `2023-11-21T13:45:30Z`

4. **Field naming conventions**:
   - Use camelCase for JSON properties(snake_case for Laravel)
   - Be consistent with property names across resources
   - Use descriptive names (avoid abbreviations). E.g: `createdAt` instead of `created`

## Status Codes

Use HTTP status codes appropriately:

1. **2xx Success**:
   - `200 OK`: Successful request (GET, PUT, PATCH)
   - `201 Created`: Resource created successfully (POST)
   - `204 No Content`: Successful request with no response body (DELETE)

2. **4xx Client Errors**:
   - `400 Bad Request`: Malformed request or invalid data
   - `401 Unauthorized`: Authentication required
   - `403 Forbidden`: Authenticated but not authorized
   - `404 Not Found`: Resource not found
   - `409 Conflict`: Request conflicts with current state
   - `422 Unprocessable Entity`: Validation errors

3. **5xx Server Errors**:
   - `500 Internal Server Error`: Unexpected server error
   - `502 Bad Gateway`: Error from upstream service
   - `503 Service Unavailable`: Service temporarily unavailable


### Client errors
There are three possible types of client errors on API calls that
receive request bodies:

1. Sending invalid JSON will result in a `400 Bad Request` response.

        HTTP/2 400
        Content-Length: 35

        {"message":"Problems parsing JSON"}

1. Sending the wrong type of JSON values will result in a `400 Bad Request` response.

        HTTP/2 400
        Content-Length: 40

        {"message":"Body should be a JSON object"}

1. Sending invalid fields will result in a `422 Unprocessable Entity` response.

        HTTP/2 422
        Content-Length: 149

        {
          "message": "Validation Failed",
          "errors": {
            "field1": [
              "The field1 is required."
            ],
            "field2": [
              "The field2 is required."
            ]
          }
        }

## Versioning
1. **URL versioning**:
   - Include version in the URL path
   - Example: `/api/v1/users`


## Error Handling

1. **Error response format**:
   ```json
   {
      "code": "RESOURCE_NOT_FOUND",
      "error": true,
      "message": "The requested resource was not found",
      "errors": {...}
   }
   ```

2. **Validation errors**:
   ```json
   {
      "code": "VALIDATION_ERROR",
      "error": true,
      "message": "Validation failed",
      "errors": {
        "field1": [
          "The field1 is required."
        ],
        "field2": [
          "The field2 is required."
        ]
      }
   }
   ```

3. **Consistent error codes**:
   - Use meaningful string constants as error codes
   - Document all possible error codes


## Documentation

1. **API specification**:
   - Use OpenAPI/[Swagger](https://swagger.io/) for API documentation
   - Keep documentation up to date with implementation

2. **Documentation content**:
   - Document all endpoints, parameters, and responses
   - Include example requests and responses
   - Document error codes and their meanings
   - Provide authentication instructions


## Performance Considerations

1. **Pagination**:
   - Always paginate list responses
   - Include pagination metadata
   - Default page size should be reasonable (20-50 items)
   - Use `page` and `per_page` query parameters

2. **Filtering**:
   - Support filtering by commonly used fields
   - Document all filter options
   - Use `filter` query parameter
   - E.g: `/articles?filter=author:john`

3. **Sorting**:
   - Support sorting by relevant fields
   - Document all sort options
   - Use `sort_by` and `sort_direction` query parameters
   - E.g: `/articles?sort_by=created_at&sort_direction=desc`

4. **Caching**:
   - Use HTTP caching headers:
     - `ETag`
     - `Cache-Control`
     - `Last-Modified`
   - Be explicit about cacheability of responses

5. **Rate limiting**:
   - Implement rate limiting to prevent abuse
   - Use these headers to communicate limits:
     - `X-RateLimit-Limit`
     - `X-RateLimit-Remaining`
     - `X-RateLimit-Reset`
   - Return `429 Too Many Requests` when limits are exceeded