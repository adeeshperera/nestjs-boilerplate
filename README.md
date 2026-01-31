# NestJS Boilerplate

A production-ready NestJS boilerplate with JWT authentication, Prisma ORM, Supabase PostgreSQL, and modern development tools.

## Features

- **JWT Authentication** with ES256 (ECDSA) encryption
- **Prisma ORM v7** with PostgreSQL (local or cloud-hosted)
- **NestJS v11** with Express v5
- **API Versioning** (v1) with Swagger documentation
- **Security** with Helmet, CORS, and rate limiting
- **Repository Pattern** for clean architecture
- **Request Logging** with Morgan
- **Context Management** with nestjs-cls
- **TypeScript** with strict type checking
- **Swagger/OpenAPI** documentation
- **Testing** setup with Jest v30
- **Modern ESLint** with TypeScript v8 support
- **Development** tools and hot reload

## Tech Stack

| Technology | Purpose | Version |
|------------|---------|---------|
| ![NestJS](https://img.shields.io/badge/nestjs-E0234E?style=flat&logo=nestjs&logoColor=white) | Backend Framework | ^11.1.12 |
| ![TypeScript](https://img.shields.io/badge/typescript-3178C6?style=flat&logo=typescript&logoColor=white) | Language | ^5.9.3 |
| ![Prisma](https://img.shields.io/badge/prisma-2D3748?style=flat&logo=prisma&logoColor=white) | ORM | ^7.3.0 |
| ![PostgreSQL](https://img.shields.io/badge/postgresql-4169E1?style=flat&logo=postgresql&logoColor=white) | Database | Latest |
| ![JWT](https://img.shields.io/badge/JWT-000000?style=flat&logo=jsonwebtokens&logoColor=white) | Authentication | ES256 |
| ![Swagger](https://img.shields.io/badge/swagger-85EA2D?style=flat&logo=swagger&logoColor=black) | API Documentation | ^11.2.5 |
| ![Jest](https://img.shields.io/badge/jest-C21325?style=flat&logo=jest&logoColor=white) | Testing | ^30.2.0 |

## Quick Start

### Prerequisites

- **Node.js** (v18 or higher, v22+ recommended)
- **Bun** package manager
- **PostgreSQL** database (local, Docker, or cloud-hosted like Supabase)
- **OpenSSL** for key generation

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/DFanso/nestjs-boilerplate
   cd nestjs-boilerplate
   ```

2. **Install dependencies**
   ```bash
   bun install
   ```

3. **Environment setup**
   ```bash
   # Create .env file
   touch .env
   
   # Edit .env with your database credentials
   nano .env
   ```
   
   See [Environment Variables](#environment-variables) section below for required values.

4. **Generate JWT keys**
   ```bash
   mkdir keys
   # Generate ECDSA private key
   openssl ecparam -name prime256v1 -genkey -noout -out keys/private.pem
   # Generate public key
   openssl ec -in keys/private.pem -pubout -out keys/public.pem
   ```

5. **Database setup**
   
   **Option A: Using Docker (Recommended for local development)**
   ```bash
   # Start PostgreSQL in Docker
   docker-compose up postgres -d
   
   # Generate Prisma client
   bunx prisma generate
   
   # Apply database migrations
   bunx prisma migrate deploy
   ```
   
   **Option B: Using existing PostgreSQL**
   ```bash
   # Ensure PostgreSQL is running and database exists
   # Then generate Prisma client
   bunx prisma generate
   
   # Push schema to database
   bunx prisma db push
   ```

6. **Start development server**
   ```bash
   bun run dev
   ```

   **Your API is now running at** `http://localhost:9000`

## Environment Variables

Create a `.env` file in the project root:

### Local PostgreSQL Database
```env
# Application Configuration
NODE_ENV=development

# Database Configuration (Local PostgreSQL)
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/nestjs_boilerplate"

# JWT Configuration
JWT_PRIVATE_KEY_PATH="./keys/private.pem"
JWT_PUBLIC_KEY_PATH="./keys/public.pem"

# Application Configuration
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001
```

### Cloud Database (Supabase)
```env
# Application Configuration
NODE_ENV=development

# Database Configuration (Supabase with connection pooling)
DATABASE_URL="postgresql://postgres.xxxxx:[PASSWORD]@aws-0-[region].pooler.supabase.com:6543/postgres"

# JWT Configuration
JWT_PRIVATE_KEY_PATH="./keys/private.pem"
JWT_PUBLIC_KEY_PATH="./keys/public.pem"

# Application Configuration
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001
```

> **Note:** Prisma v7 uses `prisma.config.ts` for database configuration. The `DATABASE_URL` from your `.env` file is automatically loaded.

## API Documentation

Once the server is running, visit:

- **Swagger UI**: `http://localhost:9000/doc`
- **API Base URL**: `http://localhost:9000/v1`

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/v1/auth/register` | Register a new user |
| `POST` | `/v1/auth/login` | Login and get JWT token |
| `GET` | `/v1/auth/profile` | Get user profile (protected) |

### Example Requests

**Register User:**
```bash
curl -X POST http://localhost:9000/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securePassword123"
  }'
```

**Login:**
```bash
curl -X POST http://localhost:9000/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securePassword123"
  }'
```

**Get Profile:**
```bash
curl -X GET http://localhost:9000/v1/auth/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Project Structure

```
.
├── src/
│   ├── auth/                    # Authentication module
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── auth.module.ts
│   │   ├── jwt.strategy.ts
│   │   ├── jwt-auth.guard.ts
│   │   └── dto/
│   ├── users/                   # Users module
│   │   ├── users.service.ts
│   │   ├── users.repository.ts
│   │   ├── users.module.ts
│   │   └── dto/
│   ├── prisma/                  # Prisma service
│   │   ├── prisma.service.ts
│   │   └── prisma.module.ts
│   ├── utils/                   # Utility functions
│   │   ├── request-logging.ts
│   │   └── exception-filter.ts
│   ├── app.module.ts            # Root module
│   ├── app.controller.ts        # Root controller
│   ├── app.service.ts           # Root service
│   └── main.ts                  # Application entry point
├── prisma/
│   ├── schema.prisma            # Database schema
│   └── migrations/              # Database migrations
├── prisma.config.ts             # Prisma v7 configuration
├── docker-compose.yml           # Docker configuration
└── package.json                 # Dependencies
```

## Available Scripts

| Script | Description |
|--------|-------------|
| `bun run start` | Start production server |
| `bun run dev` | Start development server with hot reload |
| `bun run start:debug` | Start server in debug mode |
| `bun run build` | Build the application |
| `bun run test` | Run unit tests |
| `bun run test:e2e` | Run end-to-end tests |
| `bun run test:cov` | Run tests with coverage |

## Database Operations

### Prisma Commands

| Command | Description |
|---------|-------------|
| `bunx prisma generate` | Generate Prisma client |
| `bunx prisma db push` | Push schema to database (dev) |
| `bunx prisma migrate dev` | Create and apply migration (dev) |
| `bunx prisma migrate deploy` | Apply migrations (production) |
| `bunx prisma studio` | Open Prisma Studio GUI |
| `bunx prisma migrate status` | Check migration status |
| `bunx prisma validate` | Validate schema and config |

> **Note:** Prisma v7 uses `prisma.config.ts` for configuration. Database URL and migration paths are defined there.

### Database Schema

```prisma
model User {
  id        String     @id @default(cuid())
  email     String     @unique
  password  String
  createdAt DateTime   @default(now())
  updatedAt DateTime   @updatedAt
  roles     UserRole[]
}

model UserRole {
  id     String @id @default(cuid())
  user   User   @relation(fields: [userId], references: [id])
  userId String
  role   Role
}

enum Role {
  USER
  ADMIN
}
```

## Security Features

- **Helmet** - Security headers
- **CORS** - Cross-origin resource sharing
- **Rate Limiting** - Request throttling
- **JWT with ES256** - Asymmetric encryption
- **Password Hashing** - bcrypt with salt rounds
- **Input Validation** - class-validator pipes
- **SQL Injection Protection** - Prisma ORM

## Testing

```bash
# Run unit tests
bun run test

# Run tests in watch mode
bun run test:watch

# Run e2e tests
bun run test:e2e

# Generate coverage report
bun run test:cov
```

## Recent Updates

### January 2026 Update
- ⬆️ Updated **NestJS** packages from v11.1.9 to v11.1.12
- ⬆️ Updated **Prisma ORM** from v7.1.0 to v7.3.0
- ⬆️ Updated **@nestjs/swagger** from v11.2.3 to v11.2.5
- ⬆️ Updated **@nestjs/cli** from v11.0.14 to v11.0.16
- ⬆️ Updated **TypeScript ESLint** from v8.49.0 to v8.54.0
- ⬆️ Updated **nestjs-cls** from v6.1.0 to v6.2.0
- ⬆️ Updated **Prettier** from v3.7.4 to v3.8.1
- ⬆️ Updated **@types/node** from v24.10.2 to v25.1.0
- ⬆️ Updated **supertest** from v7.1.4 to v7.2.2

### Version 11 (December 2025)
- ✨ Upgraded to **NestJS v11** with Express v5
- ✨ Upgraded to **Prisma ORM v7** with new config system
- ✨ Upgraded to **Jest v30** for improved performance
- ✨ Upgraded to **TypeScript ESLint v8**
- ✨ Updated all dependencies to latest stable versions
- 🔧 Migrated database configuration to `prisma.config.ts`
- 🔧 Made `ALLOWED_ORIGINS` optional with sensible defaults
- 🔧 Simplified local database setup (removed DIRECT_URL requirement)

## Documentation

- [Database Migration Guide](./docs/DATABASE_MIGRATION_GUIDE.md)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [NestJS](https://nestjs.com/) - Progressive Node.js framework
- [Prisma](https://prisma.io/) - Next-generation ORM
- [PostgreSQL](https://postgresql.org/) - Advanced open source database
- [Swagger](https://swagger.io/) - API documentation
- [Jest](https://jestjs.io/) - Delightful testing framework

## Support

If you have any questions or need help, please:

- Open an issue on GitHub
- Check the documentation
- Search existing issues
